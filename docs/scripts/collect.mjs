#!/usr/bin/env node
// 收集文档站数据：
//   1) 仓库内已知信息：versions.json / extensions.json / .image-metrics.json /
//      .build-state.json / .scan-results.json
//   2) registry 全量 tag：ghcr 包版本 API（需要 packages: read；失败时自动降级为仅用仓库内数据）
//
// 关键点：每个 tag 都要**解析成具体镜像**（php 完整版本 + 变体 + suite）。
// 站点存在的意义就是让人查清「era-cloud/php:8 到底是哪个 PHP 版本、哪个变体」，
// 所以表格里不能直接显示 `8` / `—`。
//
// 输出：docs/public/data/{summary,current,archived}.json
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const here = path.dirname(fileURLToPath(import.meta.url))
const repo = path.resolve(here, '../..')
const outDir = path.join(repo, 'docs/public/data')

const OWNER = process.env.GITHUB_REPOSITORY_OWNER || 'era-cloud'
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
const scanRaw = readJSON('.scan-results.json', {})

// .image-metrics.json 是数组（每项带 tag），兼容对象形式
const metrics = Array.isArray(metricsRaw)
  ? Object.fromEntries(metricsRaw.filter((m) => m && m.tag).map((m) => [m.tag, m]))
  : metricsRaw

// 当前仍在构建的组合，以及每个版本的默认 suite
const currentCombos = new Set()
const currentPhp = new Map()
const defaultDebian = {}
const defaultAlpine = {}
for (const [key, val] of Object.entries(versions)) {
  if (!val || !val.variants) continue
  currentPhp.set(key, val.version)
  const suites = val.variants.map((v) => v.split('/')[0])
  defaultDebian[key] = suites.find((s) => !s.startsWith('alpine')) || null
  defaultAlpine[key] = suites.find((s) => s.startsWith('alpine')) || null
  for (const v of val.variants) {
    const [suite, variant] = v.split('/')
    currentCombos.add(`${key}|${suite}|${variant}`)
  }
}
const variantsPresent = new Set([...currentCombos].map((c) => c.split('|')[2]))

// 扩展版本（写进表格，便于对照 label）
const extVersion = {}
const cleanVer = (v) => String(v || '').replace(/^v/, '')
for (const [pkg, entry] of Object.entries(extensions)) {
  const stem = pkg === 'swoole/swoole' ? 'swoole' : pkg === 'swow/swow-extension' ? 'swow' : null
  if (!stem) continue
  if (entry.stable) extVersion[stem] = cleanVer(entry.stable.version)
  if (entry.rc) extVersion[`${stem}-rc`] = cleanVer(entry.rc.version)
}
extVersion.thread = extVersion.swoole
extVersion['thread-rc'] = extVersion['swoole-rc']

// 扫描结果：键形如 "8.5-cli-trixie"（php minor + 变体 + suite）
const scans = {}
for (const [key, val] of Object.entries(scanRaw || {})) {
  if (!val || typeof val !== 'object') continue
  const critical = Array.isArray(val.critical) ? val.critical : []
  const high = Array.isArray(val.high) ? val.high : []
  scans[key] = {
    critical: critical.length,
    high: high.length,
    ids: [...critical, ...high].map((v) => (typeof v === 'string' ? v : v && v.id)).filter(Boolean).slice(0, 6),
  }
}

// 只做「字面拆分」：tag 里写了什么就是什么
// 注意变体名本身带 `-`（swoole-rc / swow-rc / thread-rc），所以按 token 序列匹配而不是单 token
const VARIANTS = ['swoole-rc', 'swow-rc', 'thread-rc', 'swoole', 'swow', 'thread', 'cli', 'zts']
const parseTag = (tag) => {
  const tokens = tag.split('-')
  let php = null
  let suite = null
  let variant = null
  let variantIdx = -1
  let variantLen = 0

  // PHP 版本只会出现在第一个片段（8.5 / 8.5.13 / 8）；否则 swoole-6.2 里的 6.2 会被误判
  const startIdx = PHP_RE.test(tokens[0] || '') ? ((php = tokens[0]), 1) : 0
  const prerelease = tokens[startIdx] === 'rc'

  // suite 在末尾
  if (tokens.length > startIdx && SUITE_RE.test(tokens[tokens.length - 1])) {
    suite = tokens[tokens.length - 1]
  }
  const bodyEnd = suite ? tokens.length - 1 : tokens.length

  // 变体：优先匹配两段式（swoole-rc），再匹配单段
  for (let i = startIdx; i < bodyEnd; i++) {
    const two = i + 1 < bodyEnd ? `${tokens[i]}-${tokens[i + 1]}` : null
    if (two && VARIANTS.includes(two)) {
      variant = two
      variantIdx = i
      variantLen = 2
      break
    }
    if (VARIANTS.includes(tokens[i])) {
      variant = tokens[i]
      variantIdx = i
      variantLen = 1
      break
    }
  }

  const extTokens = []
  for (let i = startIdx; i < bodyEnd; i++) {
    if (variantIdx >= 0 && i >= variantIdx && i < variantIdx + variantLen) continue
    extTokens.push(tokens[i])
  }
  const ext = variant && extTokens.length ? extTokens.join('-') : null
  return { php, suite, variant, ext, prerelease }
}

const latestMinorFor = (variant) => {
  const minis = [...new Set([...currentCombos].map((c) => c.split('|')).filter((c) => c[2] === variant).map((c) => c[0]))]
  return minis.sort((a, b) => b.localeCompare(a, 'en'))[0] || null
}

// 把 tag 解析成具体镜像：php 完整版本 + 变体 + suite
const resolveTag = (parsed) => {
  const variant = parsed.variant || 'cli'
  let minor = null
  if (parsed.php) {
    const parts = parsed.php.split('.')
    if (parts.length === 1) {
      // `8` → 当前最新的 8.x
      const cands = [...currentPhp.keys()].filter((k) => k.startsWith(`${parts[0]}.`)).sort((a, b) => b.localeCompare(a, 'en'))
      minor = cands[0] || null
    } else {
      minor = parts.slice(0, 2).join('.')
    }
  } else {
    minor = latestMinorFor(variant)
  }

  let phpFull = null
  if (minor && currentPhp.has(minor)) {
    phpFull = parsed.php && parsed.php.split('.').length >= 3 ? parsed.php : currentPhp.get(minor)
  } else if (parsed.php && parsed.php.split('.').length >= 3) {
    phpFull = parsed.php // 历史补丁版本（已不在 versions.json 里）
  }

  let suite = parsed.suite
  if (minor) {
    if (!suite) {
      // 纯轨道 tag（swoole / swoole-6.2 / swow-rc …）由「最新 alpine suite」承载；
      // cli / zts / 8 / latest / trixie 这类由默认 debian suite 承载
      // 只有「不带 PHP 版本」的纯轨道 tag（swoole / swoole-6.2）才落在最新 alpine 上；
      // 8.5-swoole 这种带 PHP 版本的落在默认 debian suite
      const isTrack = !parsed.php && parsed.variant && parsed.variant !== 'cli' && parsed.variant !== 'zts'
      suite = isTrack ? defaultAlpine[minor] || suite : defaultDebian[minor] || suite
    } else if (suite === 'alpine') {
      suite = defaultAlpine[minor] || suite
    }
  }

  // 是否属于「需要标注解析结果」的别名写法
  const ambiguous = !parsed.variant || !parsed.suite || parsed.suite === 'alpine' || !parsed.php || parsed.php.split('.').length < 3

  return { php_full: phpFull, variant, suite, ambiguous }
}

const isCurrent = (resolved, parsed) => {
  if (parsed && parsed.prerelease) return false
  const { php_full: phpFull, variant, suite } = resolved
  if (!variant || !variantsPresent.has(variant)) return false
  if (!phpFull || !suite) return false
  const minor = phpFull.split('.').slice(0, 2).join('.')
  if (currentPhp.get(minor) !== phpFull) return false
  return currentCombos.has(`${minor}|${suite}|${variant}`)
}

// 别名 tag 自己没有 metrics 条目（只按变体短名记录），回落到它解析出的具体镜像
const metricsFor = (tag, resolved) => {
  const own = metrics[tag]
  if (own && (own.size || own.size_uncompressed || own.pull_size)) return own
  const { php_full: phpFull, variant, suite } = resolved
  if (phpFull && suite) {
    const minor = phpFull.split('.').slice(0, 2).join('.')
    const fb = metrics[`${minor}-${variant}-${suite}`]
    if (fb) return fb
  }
  return own || {}
}

const scanFor = (resolved) => {
  const { php_full: phpFull, variant, suite } = resolved
  if (!phpFull || !suite) return null
  const minor = phpFull.split('.').slice(0, 2).join('.')
  return scans[`${minor}-${variant}-${suite}`] || null
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
    const known = new Set([...Object.keys(metrics), ...Object.keys(buildState)])
    registry = [...known].map((t) => ({ tag: t, created_at: null, updated_at: null }))
  }

  const seen = new Set()
  const rows = []
  for (const r of registry) {
    if (seen.has(r.tag)) continue
    seen.add(r.tag)
    const parsed = parseTag(r.tag)
    const resolved = resolveTag(parsed)
    const m = metricsFor(r.tag, resolved)
    const scan = scanFor(resolved)
    rows.push({
      tag: r.tag,
      // 解析后的具体镜像
      php_full: resolved.php_full,
      variant: resolved.variant,
      suite: resolved.suite,
      // tag 字面写法（便于看出是别名）
      raw_php: parsed.php,
      raw_suite: parsed.suite,
      raw_variant: parsed.variant,
      ambiguous: resolved.ambiguous,
      // 轨道（swoole / swoole-rc / …）
      track: parsed.variant,
      ext: parsed.ext,
      layer: ['zts', 'thread'].includes(resolved.variant) ? 'base-zts' : ['swoole', 'swoole-rc', 'swow', 'swow-rc', 'thread', 'thread-rc'].includes(resolved.variant) ? 'ext' : 'base',
      ext_version:
        (parsed.ext && parsed.ext.endsWith('rc')
          ? extVersion[`${resolved.variant}-rc`] || extVersion[resolved.variant]
          : extVersion[resolved.variant]) || null,
      archived: !isCurrent(resolved, parsed),
      size: m.size || null,
      size_uncompressed: m.size_uncompressed || null,
      pull_size: m.pull_size || null,
      built_at: m.built_at || r.updated_at || r.created_at || null,
      critical: scan ? scan.critical : null,
      high: scan ? scan.high : null,
      vuln_ids: scan ? scan.ids : null,
    })
  }
  rows.sort((a, b) => a.tag.localeCompare(b.tag, 'en'))

  const generated_at = new Date().toISOString()
  const current = rows.filter((r) => !r.archived)
  const archived = rows.filter((r) => r.archived)

  const summary = {
    generated_at,
    source,
    note,
    php: Object.fromEntries([...currentPhp.entries()].sort((a, b) => b[0].localeCompare(a[0], 'en'))),
    extensions: extVersion,
    counts: {
      tags: rows.length,
      current: current.length,
      archived: archived.length,
      base: current.filter((r) => r.layer !== 'ext').length,
      ext: current.filter((r) => r.layer === 'ext').length,
      with_critical: current.filter((r) => (r.critical || 0) > 0).length,
      with_high: current.filter((r) => (r.high || 0) > 0).length,
    },
    scanned_variants: Object.keys(scans).length,
  }

  fs.mkdirSync(outDir, { recursive: true })
  const write = (name, obj) => fs.writeFileSync(path.join(outDir, name), JSON.stringify(obj))
  write('current.json', { generated_at, source, tags: current })
  write('archived.json', { generated_at, source, tags: archived })
  write('summary.json', { ...summary })
  // 兼容旧链接
  write('tags.json', { generated_at, source, tags: rows })
  console.log(
    `tags: ${rows.length} (current ${current.length} / archived ${archived.length}), source: ${source}${note ? ` (${note})` : ''}`,
  )
}

main().catch((e) => {
  console.error('collect failed:', e)
  process.exit(1)
})
