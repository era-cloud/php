<script setup>
import { ref, onMounted } from 'vue'
import { withBase } from 'vitepress'

const s = ref(null)
const err = ref('')
onMounted(async () => {
  try {
    const res = await fetch(withBase('/data/summary.json'), { cache: 'no-cache' })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    s.value = await res.json()
  } catch (e) {
    err.value = String(e && e.message ? e.message : e)
  }
})
</script>

# era-cloud PHP 镜像

PHP 运行时的 Docker 镜像，额外带 swoole / swow 扩展，发布到两个 registry：

- `ghcr.io/era-cloud/php`（主，zstd 压缩）
- 阿里云 ACR（只同步扩展变体）

## 30 秒选择

| 我想要 | 用这个 tag |
| --- | --- |
| 纯 PHP（基础镜像，已含常用扩展） | `8.5-cli-trixie` |
| 纯 PHP + ZTS | `8.5-zts-trixie` |
| swoole（稳定版） | `8.5-swoole-trixie` |
| swoole + 线程模式 | `8.5-thread-trixie` |
| 试 swoole 预发布 | `8.5-swoole-rc-trixie` |
| swow | `8.5-swow-trixie` |
| 钉死扩展版本 | `8.5-swoole-6.2.6-trixie` |
| 不关心 PHP 版本，只要最新可用 | `swoole` / `swow` / `thread` |

::: warning ACR 只提供扩展变体
阿里云 ACR 只同步 `swoole` / `swow` / `thread` 及其 rc 轨。**基础镜像 `cli` / `zts` 只在 ghcr 提供**
（ACR 上残留的 cli/zts tag 已停止更新，请勿使用）。
:::

::: tip 两个约定
- 不绑 PHP 版本的短 tag（`swoole`、`swoole-6.2`）指向**最新一个实际存在该扩展的 PHP 版本** + **最新 alpine suite**，当前即 PHP 8.5 + alpine3.24。
- 所有 tag 的完整清单（含历史/已归档）见 [全部 tag 索引](/tags)。
:::

## 当前状态

<p v-if="err" class="warn">数据加载失败：{{ err }}</p>
<table v-else-if="s">
  <tbody>
    <tr><td>PHP 版本</td><td>
      <code v-for="(v, k) in s.php" :key="k" style="margin-right: 8px">{{ k }} = {{ v }}</code>
    </td></tr>
    <tr><td>扩展版本</td><td>
      <code v-for="(v, k) in s.extensions" :key="k" style="margin-right: 8px">{{ k }} = {{ v }}</code>
    </td></tr>
    <tr><td>tag 总数</td><td>{{ s.counts.tags }}（当前 {{ s.counts.current }} / 历史归档 {{ s.counts.archived }}）</td></tr>
    <tr><td>安全扫描</td><td>已覆盖 {{ s.scanned_variants }} 个变体；当前 tag 中 {{ s.counts.with_critical }} 个带 CRITICAL、{{ s.counts.with_high }} 个带 HIGH</td></tr>
    <tr><td>数据更新时间</td><td>{{ s.generated_at }}</td></tr>
  </tbody>
</table>

## 两层结构

```
第一层 base   cli / zts      FROM debian:<suite>-slim | alpine:<ver>
                             → 编译 PHP，并装好全部常用扩展（bcmath gd intl zip soap …）

第二层 ext    swoole / swow / thread (+ rc 轨)
                             FROM ghcr.io/era-cloud/php:<php>-<cli|zts>-<suite>
                             → 只编译扩展本体
```

这样做的直接好处：**扩展版本升级不会重编 PHP**。base 镜像构建约 7–13 分钟，扩展层只需约 2 分钟。

::: warning base 镜像包含多个扩展
`cli` / `zts` 不再是"极简 PHP"：它们已经装好 `bcmath bz2 calendar exif ffi gd gettext intl
mysqli pcntl pdo_mysql pdo_pgsql shmop soap sockets sysvmsg sysvsem sysvshm tidy zip`
以及 `ds / igbinary / msgpack / redis`。如果你要的是最小镜像，请注意体积（trixie 约 800MB 未压缩）。
:::

## 页面导航

- [基础镜像（cli / zts）](/base)
- [扩展镜像（swoole / swow / thread）](/extensions)
- [全部 tag 索引](/tags)

<style scoped>
.warn {
  color: var(--vp-c-warning-1);
  font-size: 13px;
}
</style>
