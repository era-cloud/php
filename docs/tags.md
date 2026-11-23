# 全部 tag 索引

数据来自 ghcr 的包版本列表（全量，含已不再构建的历史 tag），并合并仓库内的
`versions.json` / `extensions.json` / `.image-metrics.json` / `.scan-results.json`。

### 每一行都会被解析成具体镜像

像 `8`、`latest`、`cli`、`swoole` 这种别名 tag，表格里会直接告诉你它**实际指向哪个镜像**：

```
tag: 8
PHP 版本: 8.6.0      变体: cli       suite: trixie
→ 8.6.0-cli-trixie   （tag 下面那行小字就是解析结果）
```

也就是说 `docker pull era-cloud/php:8` 拉到的就是 **PHP 8.6.0 的 cli 变体、trixie 基底**。
所有不完整的 tag（缺 PHP 补丁号、缺变体、缺 suite）都会显示这行解析结果。

- **历史**：registry 里仍然存在、但指向的镜像组合已不再构建的 tag（例如旧 PHP 补丁版本）
- 勾选“含历史 tag”会额外加载归档数据（默认不加载，首屏更快）
- 每页 200 行，用底部翻页；筛选条件变化会自动回到第 1 页

<TagTable />

::: tip 关于安全列
**C** = CRITICAL 数量，**H** = HIGH 数量（来源：Trivy 扫描，忽略策略见仓库 `rego-policy.rego`）。
把鼠标停在数字上可以看到具体 CVE 编号。“只看有 CRITICAL/HIGH” 可以快速过滤。
:::

::: tip 关于体积与构建时间
- **内容大小**：容器文件系统展开后的字节数（`docker export`，≈ 落盘实际占用）
- **下载**：registry 清单里压缩层的总量（实际要下载的字节数）

内容大小会比 `docker images` 显示的数字**小**（后者按层累加，含跨层已删除的文件）。
两者都只统计 linux/amd64。刚发布的镜像如果还没跑过测量，会显示 `—`。
:::

::: tip 关于「基于」列
- 基础镜像行显示官方父镜像：`debian:trixie-slim` / `alpine:3.24`
- 扩展镜像行显示它 `FROM` 的自家 base tag：如 `8.5-cli-trixie`、`8.5-zts-trixie`
:::
