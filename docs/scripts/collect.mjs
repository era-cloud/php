#!/usr/bin/env node
// 收集文档站数据：
//   1) 仓库内已知信息：versions.json / extensions.json / .image-metrics.json / .build-state.json
//   2) registry 全量 tag：ghcr 包版本 API（需要 packages: read；失败时自动降级为仅用仓库内数据）
// 输出：docs/public/data/tags.json、docs/public/data/summary.json
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const here = path.dirname(fileURLToPath(import.meta.url))
const repo = path.resolve(here, '../..')
const outDir = path.join(repo, 'docs/public/data')

const OWNER = process.env.GITHUB_REPOSITORY_OWNER || 'era-cloud'
const REPO = (process.env.GITHUB_REPOSITORY || 'era-cloud/php').split('/')[1]
const PKG = process.env.PKG_NAME || 'php'
const TOKEN = process.env.GITHUB_TOKEN || ''

const VARIANT_RE = /^(cli|zts|swoole-rc|swoole|swow-rc|swow|thread-rc|thread)$/
const PHP_RE = /^(\d+\.\d+\.\d+(?:RC\d+|rc\d+)?|\d+\.\d+|\d+)$/
const SUITE_RE = /^(trixie|bookworm|bullseye|buster|alpine\d*\.?\d*|alpine)$/

const readJSON = (p, fallback) => {
  try {
    return JSON.parse(fs.readFileSync(path.join(repo, p), 'utf8'))
  } catch {
    return fallback
  }
}

const versions = readJSON('versions.json', {})
const extensions = readJSON('extensions.json', {})
const metricsRaw = readJSON('.image-metrics.json', [])
const buildState = readJSON('.build-state.json', {})

// .image-metrics.json 是数组（每项带 tag），兼容对象形式
const metrics = Array.isArray(metricsRaw)
  ? Object.fromEntries(metricsRaw.filter((m) => m && m.tag).map((m) => [m.tag, m]))
  : metricsRaw

// 当前仍在构建的 (php minor, variant, suite) 组合
const currentCombos = new Set()
const currentPhp = new Map() // php minor -> full version
for (const [key, val] of Object.entries(versions)) {
  if (!val || !val.variants) continue
  currentPhp.set(key, val.version)
  for (const v of val.variants) {
    const [suite, variant] = v.split('/')
    currentCombos.add(`${key}|${suite}|${variant}`)
  }
}
const variantsPresent = new Set([...currentCombos].map((c) => c.split('|')[2]))

// 扩展版本（写进表格，便于对照 label）
const extVersion = {}
for (const [pkg, entry] of Object.entries(extensions)) {
  const stem = pkg === 'swoole/swoole' ? 'swoole' : pkg === 'swow/swow-extension' ? 'swow' : null
  if (!stem) continue
  const clean = (v) => String(v || '').replace(/^v/, '')
  if (entry.stable) extVersion[stem] = clean(entry.stable.version)
  if (entry.rc) extVersion[`${stem}-rc`] = clean(entry.rc.version)
}
extVersion.thread = extVersion.swoole
extVersion['thread-rc'] = extVersion['swoole-rc']

const parseTag = (tag) => {
  const tokens = tag.split('-')
  let php = null
  let suite = null
  let variant = null
  const extTokens = []
  for (const t of tokens) {
    if (suite === null && SUITE_RE.test(t)) {
      suite = t
      continue
    }
    if (php === null && PHP_RE.test(t)) {
      php = t
      continue
    }
    if (variant === null && VARIANT_RE.test(t)) {
      variant = t
      continue
    }
    extTokens.push(t)
  }
  // 只有识别到变体时，剩余片段才算扩展版本（避免把 latest / 8 之类当成扩展）
  const ext = variant && extTokens.length ? extTokens.join('-') : null
  return { php, suite, variant, ext }
}

const phpMinor = (php) => (php ? php.split('.').slice(0, 2).join('.') : null)

const isCurrent = ({ php, suite, variant }) => {
  // 不带变体的 tag 指的是默认变体（cli）
  const v = variant || 'cli'
  if (!variantsPresent.has(v)) return false
  if (!php) return true // 无 PHP 版本的轨道 tag（swoole / swoole-6.2 / latest）
  const parts = php.split('.')
  if (parts.length === 1) {
    // 8 → major 别名；带 suite 时还要确认该 suite 仍在构建
    const minis = [...currentPhp.keys()].filter((k) => k.startsWith(`${parts[0]}.`))
    if (!minis.length) return false
    if (!suite) return true
    return minis.some((m) =>
      suite === 'alpine'
        ? [...currentCombos].some((c) => c.startsWith(`${m}|alpine`) && c.endsWith(`|${v}`))
        : currentCombos.has(`${m}|${suite}|${v}`),
    )
  }
  const minor = parts.slice(0, 2).join('.')
  if (!currentPhp.has(minor)) return false
  // 带完整补丁版本（8.5.10）时，必须正好是当前构建的那个补丁版本
  if (parts.length >= 3 && php !== currentPhp.get(minor)) return false
  if (!suite) return true // 不绑 suite 的 tag
  // alpine 是「该版本默认 alpine suite」的简写
  if (suite === 'alpine') {
    return [...currentCombos].some((c) => c.startsWith(`${minor}|alpine`) && c.endsWith(`|${v}`))
  }
  return currentCombos.has(`${minor}|${suite}|${v}`)
}

async function fetchRegistryTags() {
  if (!TOKEN) throw new Error('no GITHUB_TOKEN')
  const tags = []
  for (let page = 1; page <= 100; page++) {
    const url = `https://api.github.com/orgs/${OWNER}/packages/container/${PKG}/versions?per_page=100&page=${page}`
    const res = await fetch(url, {
      headers: {
        Authorization: `Bearer ${TOKEN}`,
        Accept: 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    })
    if (!res.ok) throw new Error(`HTTP ${res.status} ${await res.text().catch(() => '')}`.slice(0, 200))
    const batch = await res.json()
    if (!Array.isArray(batch) || batch.length === 0) break
    for (const v of batch) {
      for (const t of v.metadata?.container?.tags || []) {
        tags.push({ tag: t, created_at: v.created_at, updated_at: v.updated_at })
      }
    }
    if (batch.length < 100) break
  }
  return tags
}

const main = async () => {
  let registry = []
  let source = 'ghcr'
  let note = ''
  try {
    registry = await fetchRegistryTags()
  } catch (e) {
    source = 'fallback'
    note = String(e.message || e)
    // 降级：用 metrics 里的 tag + build-state 的键
    const known = new Set([...Object.keys(metrics), ...Object.keys(buildState)])
    registry = [...known].map((t) => ({ tag: t, created_at: null, updated_at: null }))
  }

  const seen = new Set()
  const rows = []
  for (const r of registry) {
    if (seen.has(r.tag)) continue
    seen.add(r.tag)
    const parsed = parseTag(r.tag)
    const m = metrics[r.tag] || {}
    rows.push({
      tag: r.tag,
      ...parsed,
      layer: !parsed.variant || ['cli', 'zts'].includes(parsed.variant) ? 'base' : 'ext',
      ext_version: parsed.variant ? String(extVersion[parsed.variant] || '').replace(/^v/, '') || null : null,
      archived: !isCurrent(parsed),
      size: m.size || null,
      pull_size: m.pull_size || null,
      built_at: m.built_at || r.updated_at || r.created_at || null,
    })
  }
  rows.sort((a, b) => a.tag.localeCompare(b.tag, 'en'))

  const summary = {
    generated_at: new Date().toISOString(),
    source,
    note,
    php: Object.fromEntries([...currentPhp.entries()].sort((a, b) => b[0].localeCompare(a[0], 'en'))),
    extensions: extVersion,
    counts: {
      tags: rows.length,
      current: rows.filter((r) => !r.archived).length,
      archived: rows.filter((r) => r.archived).length,
      base: rows.filter((r) => r.layer === 'base').length,
      ext: rows.filter((r) => r.layer === 'ext').length,
    },
  }

  fs.mkdirSync(outDir, { recursive: true })
  fs.writeFileSync(path.join(outDir, 'tags.json'), JSON.stringify({ generated_at: summary.generated_at, source, tags: rows }))
  fs.writeFileSync(path.join(outDir, 'summary.json'), JSON.stringify(summary, null, 2))
  console.log(`tags: ${rows.length} (current ${summary.counts.current} / archived ${summary.counts.archived}), source: ${source}${note ? ` (${note})` : ''}`)
}

main().catch((e) => {
  console.error('collect failed:', e)
  process.exit(1)
})
