# 全部 tag 索引

数据来自 ghcr 的包版本列表（全量，含已不再构建的历史 tag），并合并仓库内的
`versions.json` / `extensions.json` / `.image-metrics.json`。

- **当前**：按当前规则仍在构建的 tag
- **已归档**：registry 里仍然存在、但当前规则不再构建的历史 tag（例如旧 PHP 补丁版本）

勾选“含历史/已归档”即可看到全部。

<TagTable />

::: tip 关于体积与构建时间
“体积”是镜像层解压后的总量，“拉取”是实际下载的压缩层体积。两者都只统计 linux/amd64。
:::
