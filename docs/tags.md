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

<TagTable />

::: tip 关于安全列
**C** = CRITICAL 数量，**H** = HIGH 数量（来源：Trivy 扫描，忽略策略见仓库 `rego-policy.rego`）。
把鼠标停在数字上可以看到具体 CVE 编号。“只看有 CRITICAL/HIGH” 可以快速过滤。
:::

::: tip 关于体积与构建时间
- **解压后**：`docker save` 得到的字节数（落盘后大致占用空间）
- **下载**：registry 清单里压缩层的总量（实际要下载的字节数）

两者都只统计 linux/amd64。刚发布的镜像如果还没跑过测量，会显示 `—`。
:::
