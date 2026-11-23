<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { withBase } from 'vitepress'

const props = defineProps({
  layer: { type: String, default: '' }, // '' | 'base' | 'ext'
})

const current = ref([])
const archived = ref([])
const archivedLoaded = ref(false)
const loading = ref(true)
const source = ref('')
const generatedAt = ref('')
const error = ref('')

const fPhp = ref('')
const fVariant = ref('')
const fSuite = ref('')
const fQ = ref('')
const showArchived = ref(false)
const onlyVuln = ref(false)
const page = ref(1)
const PAGE_SIZE = 200

const getJSON = async (name) => {
  const res = await fetch(withBase(`/data/${name}`), { cache: 'no-cache' })
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  return res.json()
}

onMounted(async () => {
  try {
    const j = await getJSON('current.json')
    current.value = j.tags || []
    source.value = j.source || ''
    generatedAt.value = j.generated_at || ''
  } catch (e) {
    error.value = String(e && e.message ? e.message : e)
  } finally {
    loading.value = false
  }
})

// 归档数据单独一个文件（约 3.5MB 原始），勾选时才拉
watch(showArchived, async (on) => {
  if (!on || archivedLoaded.value) return
  try {
    const j = await getJSON('archived.json')
    archived.value = j.tags || []
  } catch (e) {
    error.value = String(e && e.message ? e.message : e)
  } finally {
    archivedLoaded.value = true
  }
})

const all = computed(() => (showArchived.value ? [...current.value, ...archived.value] : current.value))
const scoped = computed(() => all.value.filter((r) => !props.layer || r.layer === props.layer))
const uniq = (arr) => [...new Set(arr.filter(Boolean))]
const phps = computed(() => uniq(scoped.value.map((r) => r.php_full)).sort().reverse())
const variants = computed(() => uniq(scoped.value.map((r) => r.variant)).sort())
const suites = computed(() => uniq(scoped.value.map((r) => r.suite)).sort())

const filtered = computed(() => {
  const q = fQ.value.trim().toLowerCase()
  return scoped.value
    .filter((r) => (onlyVuln.value ? (r.critical || 0) > 0 || (r.high || 0) > 0 : true))
    .filter((r) => !fPhp.value || r.php_full === fPhp.value)
    .filter((r) => !fVariant.value || r.variant === fVariant.value)
    .filter((r) => !fSuite.value || r.suite === fSuite.value)
    .filter((r) => {
      if (!q) return true
      const hay = [r.tag, r.php_full, r.variant, r.suite, r.ext, r.ext_version].filter(Boolean).join(' ').toLowerCase()
      return hay.includes(q)
    })
    .sort((a, b) => a.tag.localeCompare(b.tag, 'en'))
})

const totalPages = computed(() => Math.max(1, Math.ceil(filtered.value.length / PAGE_SIZE)))
const pageRows = computed(() => filtered.value.slice((page.value - 1) * PAGE_SIZE, page.value * PAGE_SIZE))
watch([fPhp, fVariant, fSuite, fQ, onlyVuln, showArchived], () => {
  page.value = 1
})

const mb = (n) => (n ? `${(n / 1048576).toFixed(0)} MB` : '—')
const resolvedName = (r) => [r.php_full, r.variant, r.suite].filter(Boolean).join('-')
const reset = () => {
  fPhp.value = ''
  fVariant.value = ''
  fSuite.value = ''
  fQ.value = ''
}
</script>

<template>
  <div class="tag-toolbar">
    <input v-model="fQ" placeholder="搜索 tag / PHP / 变体 / suite" />
    <select v-model="fPhp"><option value="">全部 PHP</option><option v-for="p in phps" :key="p" :value="p">{{ p }}</option></select>
    <select v-model="fVariant"><option value="">全部变体</option><option v-for="v in variants" :key="v" :value="v">{{ v }}</option></select>
    <select v-model="fSuite"><option value="">全部 suite</option><option v-for="s in suites" :key="s" :value="s">{{ s }}</option></select>
    <label class="archived"><input type="checkbox" v-model="showArchived" /> 含历史 tag</label>
    <label class="archived"><input type="checkbox" v-model="onlyVuln" /> 只看有 CRITICAL/HIGH</label>
    <button @click="reset">清空</button>
  </div>

  <p v-if="error" class="warn">数据加载失败：{{ error }}（页面仍可阅读，表格需等下一次构建刷新）</p>
  <p v-else-if="loading">加载中…</p>
  <p v-else class="meta">
    共 <strong>{{ filtered.length }}</strong> 个 tag<template v-if="showArchived">（含历史）</template>（数据源：{{ source || '未知' }}<template v-if="generatedAt">，更新于 {{ generatedAt }}</template>）
  </p>

  <table v-if="!loading && !error">
    <thead>
      <tr>
        <th>tag</th>
        <th>PHP 版本</th>
        <th>变体</th>
        <th>suite</th>
        <th>扩展版本</th>
        <th>基于</th>
        <th>安全</th>
        <th>内容大小</th>
        <th>下载</th>
        <th>构建时间</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="r in pageRows" :key="r.tag" :class="{ archived: r.archived }">
        <td>
          <code>{{ r.tag }}</code>
          <span v-if="r.archived" class="badge">历史</span>
          <div v-if="r.ambiguous" class="resolve">→ {{ resolvedName(r) }}</div>
        </td>
        <td><strong>{{ r.php_full || '—' }}</strong></td>
        <td>{{ r.variant || '—' }}</td>
        <td>{{ r.suite || '—' }}</td>
        <td>{{ r.ext_version || '—' }}</td>
        <td class="based"><code v-if="r.based_on">{{ r.based_on }}</code><template v-else>—</template></td>
        <td class="sec" :title="(r.vuln_ids || []).join(', ')">
          <template v-if="r.critical === null && r.high === null">—</template>
          <template v-else>
            <span v-if="r.critical" class="crit">C{{ r.critical }}</span>
            <span v-if="r.high" class="high">H{{ r.high }}</span>
            <span v-if="!r.critical && !r.high" class="clean">无</span>
          </template>
        </td>
        <td>{{ mb(r.size_uncompressed) }}</td>
        <td>{{ mb(r.pull_size) }}</td>
        <td>{{ r.built_at ? r.built_at.slice(0, 10) : '—' }}</td>
      </tr>
    </tbody>
  </table>

  <div v-if="!loading && !error && totalPages > 1" class="pager">
    <button :disabled="page <= 1" @click="page = page - 1">上一页</button>
    <span>第 {{ page }} / {{ totalPages }} 页</span>
    <button :disabled="page >= totalPages" @click="page = page + 1">下一页</button>
    <button @click="page = 1">回到首页</button>
  </div>
</template>

<style scoped>
.tag-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 16px 0;
}
.tag-toolbar input,
.tag-toolbar select,
.tag-toolbar button {
  padding: 4px 8px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 6px;
  background: var(--vp-c-bg);
  color: var(--vp-c-text-1);
  font-size: 13px;
}
.tag-toolbar input {
  min-width: 240px;
}
.archived {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: var(--vp-c-text-2);
}
.based code {
  font-size: 11px;
}
.pager {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 12px 0;
  font-size: 13px;
  color: var(--vp-c-text-2);
}
.pager button {
  padding: 4px 10px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 6px;
  background: var(--vp-c-bg);
  color: var(--vp-c-text-1);
  font-size: 13px;
  cursor: pointer;
}
.pager button:disabled {
  opacity: 0.4;
  cursor: default;
}
.meta {
  font-size: 13px;
  color: var(--vp-c-text-2);
}
.warn {
  color: var(--vp-c-warning-1);
  font-size: 13px;
}
table {
  display: block;
  overflow-x: auto;
  font-size: 13px;
}
tr.archived td {
  opacity: 0.55;
}
.resolve {
  margin-top: 2px;
  font-family: var(--vp-font-family-mono);
  font-size: 11px;
  color: var(--vp-c-text-3);
}
.sec span {
  display: inline-block;
  margin-right: 4px;
  padding: 0 6px;
  border-radius: 999px;
  font-size: 11px;
}
.crit {
  background: var(--vp-c-danger-soft);
  color: var(--vp-c-danger-1);
}
.high {
  background: var(--vp-c-warning-soft);
  color: var(--vp-c-warning-1);
}
.clean {
  background: var(--vp-c-default-soft);
  color: var(--vp-c-text-2);
}
.badge {
  margin-left: 6px;
  padding: 0 6px;
  border-radius: 999px;
  background: var(--vp-c-default-soft);
  font-size: 11px;
  color: var(--vp-c-text-2);
}
</style>
