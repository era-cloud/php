# 扩展镜像（swoole / swow / thread）

扩展镜像只负责编译扩展本体，PHP 与通用扩展全部继承自基础镜像：

```
FROM ghcr.io/era-cloud/php:<php>-<cli|zts>-<suite>
```

| 变体 | base 用的变体 | 说明 |
| --- | --- | --- |
| `swoole` | `cli` | swoole 稳定版（curl / cares / brotli / pgsql / sqlite） |
| `thread` | `zts` | 同 swoole，额外开 `--enable-swoole-thread`（ZTS） |
| `swow` | `cli` | swow 稳定版 |
| `swoole-rc` | `cli` | swoole 预发布轨 |
| `swow-rc` | `cli` | swow 预发布轨 |

::: info 预发布轨的版本口径
`swoole-rc` 取 swoole 仓库最新 pre-release；`swow-rc` 的**版本号**取核心仓 `swow/swow` 的
pre-release tag，实际安装的是 `swow-extension` 的 develop 分支 HEAD（alpha 每天可能变，
因此仓库对 alpha 级变更只自动开 issue 提醒，不自动采用）。
:::

## tag 语法

以 PHP 8.5 + swoole 6.2.6 为例：

```bash
# 轨道级（不绑 PHP 版本，指向最新可用 PHP + 最新 alpine）
swoole                 # 最新可用：php 8.5 + swoole 6.2.6 + alpine3.24
swoole-6               # 扩展 major
swoole-6.2             # 扩展 major.minor
swoole-6.2.6           # 扩展完整版本

# PHP 短版本 + 扩展
8.5-swoole
8.5-swoole-6.2
8.5-swoole-6.2.6

# 再做 suite 组合
8.5-swoole-6.2-trixie
8.5-swoole-6.2.6-alpine3.24

# PHP 完整版本 + 扩展完整版本（最精确）
8.5.13-swoole-6.2.6
8.5.13-swoole-6.2.6-trixie
```

预发布轨沿用同一套结构，但只到 `major.minor`（完整 rc 号如 `6.3.0-rc2` 只写进 label）：

```bash
swoole-rc       swoole-6-rc       swoole-6.3-rc
8.5-swoole-rc   8.5-swoole-6.3-rc
```

## 怎么查扩展版本

```bash
docker inspect --format '{{json .Config.Labels}}' ghcr.io/era-cloud/php:8.5-swoole-trixie \
  | jq -r '."cn.era-cloud.base", ."cn.era-cloud.ext.swoole"'
```

会输出这一层基于哪个 base tag 构建，以及扩展的实际版本。

## 支持矩阵

| PHP | swoole | swoole-rc | swow | swow-rc | thread |
| --- | --- | --- | --- | --- | --- |
| 8.6 | — | — | — | — | — |
| 8.5 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 8.4 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 8.3 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 8.2 | ✅ | ✅ | ✅ | ✅ | ✅ |

## tag 列表

下表的「基于」列就是这一层 `FROM` 的自家 base tag（`thread` 用 `zts`，其余用 `cli`）。

<TagTable layer="ext" />
