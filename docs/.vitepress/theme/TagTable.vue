<script setup>
import { ref, computed, onMounted } from 'vue'
import { withBase } from 'vitepress'

const props = defineProps({
  layer: { type: String, default: '' }, // 'base' | 'ext' | ''
})

const rows = ref([])
const loading = ref(true)
const source = ref('')
const generatedAt = ref('')
const error = ref('')

const fPhp = ref('')
const fVariant = ref('')
const fSuite = ref('')
const fQ = ref('')
const showArchived = ref(false)

onMounted(async () => {
  try {
    const res = await fetch(withBase('/data/tags.json'), { cache: 'no-cache' })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const json = await res.json()
    rows.value = json.tags || []
    source.value = json.source || ''
    generatedAt.value = json.generated_at || ''
  } catch (e) {
    error.value = String(e && e.message ? e.message : e)
  } finally {
    loading.value = false
  }
})

const scoped = computed(() => rows.value.filter((r) => !props.layer || r.layer === props.layer))
const uniq = (arr) => [...new Set(arr.filter(Boolean))]
const phps = computed(() => uniq(scoped.value.map((r) => r.php)).sort().reverse())
const variants = computed(() => uniq(scoped.value.map((r) => r.variant)).sort())
const suites = computed(() => uniq(scoped.value.map((r) => r.suite)).sort())

const filtered = computed(() => {
  const q = fQ.value.trim().toLowerCase()
  return scoped.value
    .filter((r) => (showArchived.value ? true : !r.archived))
    .filter((r) => !fPhp.value || r.php === fPhp.value)
    .filter((r) => !fVariant.value || r.variant === fVariant.value)
    .filter((r) => !fSuite.value || r.suite === fSuite.value)
    .filter((r) => !q || r.tag.toLowerCase().includes(q))
    .sort((a, b) => a.tag.localeCompare(b.tag, 'en'))
})

const mb = (n) => (n ? `${(n / 1048576).toFixed(0)} MB` : '—')
const reset = () => {
  fPhp.value = ''
  fVariant.value = ''
  fSuite.value = ''
  fQ.value = ''
}
</script>
<template>

<div class="tag-toolbar">
  <input v-model="fQ" placeholder="搜索 tag（如 swoole-6.2 / alpine3.24）" />
  <select v-model="fPhp"><option value="">全部 PHP</option><option v-for="p in phps" :key="p" :value="p">{{ p }}</option></select>
  <select v-model="fVariant"><option value="">全部变体</option><option v-for="v in variants" :key="v" :value="v">{{ v }}</option></select>
  <select v-model="fSuite"><option value="">全部 suite</option><option v-for="s in suites" :key="s" :value="s">{{ s }}</option></select>
  <label class="archived"><input type="checkbox" v-model="showArchived" /> 含历史/已归档</label>
  <button @click="reset">清空</button>
</div>

<p v-if="error" class="warn">数据加载失败：{{ error }}（页面仍可阅读，表格需等下一次构建刷新）</p>
<p v-else-if="loading">加载中…</p>
<p v-else class="meta">
  共 <strong>{{ filtered.length }}</strong> 个 tag（数据源：{{ source || '未知' }}<template v-if="generatedAt">，更新于 {{ generatedAt }}</template>）
</p>

<table v-if="!loading && !error">
  <thead>
    <tr>
      <th>tag</th><th>PHP</th><th>变体</th><th>suite</th><th>扩展版本</th><th>体积</th><th>拉取</th><th>构建时间</th>
    </tr>
  </thead>
  <tbody>
    <tr v-for="r in filtered.slice(0, 500)" :key="r.tag" :class="{ archived: r.archived }">
      <td><code>{{ r.tag }}</code><span v-if="r.archived" class="badge">已归档</span></td>
      <td>{{ r.php || '—' }}</td>
      <td>{{ r.variant || '—' }}</td>
      <td>{{ r.suite || '—' }}</td>
      <td>{{ r.ext_version || '—' }}</td>
      <td>{{ mb(r.size) }}</td>
      <td>{{ mb(r.pull_size) }}</td>
      <td>{{ r.built_at ? r.built_at.slice(0, 10) : '—' }}</td>
    </tr>
  </tbody>
</table>

<p v-if="!loading && !error && filtered.length > 500" class="meta">
  只显示前 500 行，请用上方筛选缩小范围。
</p>

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
.badge {
  margin-left: 6px;
  padding: 0 6px;
  border-radius: 999px;
  background: var(--vp-c-default-soft);
  font-size: 11px;
  color: var(--vp-c-text-2);
}
</style>
