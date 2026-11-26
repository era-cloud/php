# PHP Docker Images — era-cloud/php

[![Release](https://img.shields.io/github/actions/workflow/status/era-cloud/php/release.yml?branch=main&label=Release)](https://github.com/era-cloud/php/actions/workflows/release.yml)
[![Build and Push](https://img.shields.io/github/actions/workflow/status/era-cloud/php/ci.yml?branch=main&label=Build%20and%20Push)](https://github.com/era-cloud/php/actions/workflows/ci.yml)
[![Security Scan](https://img.shields.io/github/actions/workflow/status/era-cloud/php/security-scan.yml?branch=main&label=Security%20Scan)](https://github.com/era-cloud/php/actions/workflows/security-scan.yml)
[![License](https://img.shields.io/github/license/era-cloud/php)](https://github.com/era-cloud/php/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/era-cloud/php)](https://github.com/era-cloud/php/commits/main)
<!-- PHP-BADGE-START -->
[![PHP](https://img.shields.io/badge/PHP-8.2%20%7C%208.3%20%7C%208.4%20%7C%208.5%20%7C%208.6-777BB4)](https://www.php.net/)
<!-- PHP-BADGE-END -->
[![Repo Size](https://img.shields.io/github/repo-size/era-cloud/php)](https://github.com/era-cloud/php)
[![Variants](https://img.shields.io/badge/variants-cli%20%7C%20zts%20%7C%20swoole%20%7C%20swow%20%7C%20thread-blue)](https://github.com/era-cloud/php/pkgs/container/php)
[![Contributors](https://img.shields.io/github/contributors/era-cloud/php)](https://github.com/era-cloud/php/graphs/contributors)

基于 [Docker 官方 php 镜像](https://github.com/docker-library/php) 构建的增强镜像，内置 **swoole / swow / thread（ZTS + swoole 线程模式）** 及 **redis 增强（igbinary/msgpack/lz4/zstd）**，扩展安装全面采用 [PIE](https://php.github.io/pie/)（PECL 已弃用并下线）。

提供 **ghcr.io** 与**国内 Aliyun ACR** 双镜像源。

> ⚠️ **ACR 只同步扩展变体**（swoole / swow / thread 及其 rc 轨）。
> 基础镜像 `cli` / `zts` **只在 ghcr 提供**；ACR 上残留的 cli/zts tag 已停止更新，请勿使用。

> 📖 **完整文档站**：<https://era-cloud.github.io/php/> — 快速选择、基础镜像、扩展镜像、**全部 tag 索引**
> （含历史/已归档，可按 PHP 版本、变体、suite 筛选）。

## 分层结构

```
base   cli / zts                      编译 PHP + 全部常用扩展（bcmath gd intl zip soap …）
ext    swoole / swow / thread (+ rc)  FROM 自家 base，只编译扩展本体
```

扩展版本升级不会重编 PHP，因此扩展变体重建只需约 2 分钟（base 为 7–13 分钟）。

## 镜像源

```sh
# ghcr.io
docker pull ghcr.io/era-cloud/php:8.5-swoole

# 国内 Aliyun ACR
docker pull crpi-ae6l51vlbqurnd6c.cn-chengdu.personal.cr.aliyuncs.com/eracloud/php:8.5-swoole
```

## 版本矩阵

<!-- VERSION-MATRIX-START -->
### 稳定轨
| PHP | cli | zts | swoole | swow | thread |
|-----|-----|-----|-----|-----|-----|
| **8.6** (8.6.0) | ✅ | ✅ | — | — | — |
| **8.5** (8.5.13) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.4** (8.4.28) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.3** (8.3.37) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.2** (8.2.36) | ✅ | ✅ | ✅ | ✅ | ✅ |

### 预发布轨
| PHP | swoole-rc | swow-rc |
|-----|-----|-----|
| **8.6** (8.6.0) | — | — |
| **8.5** (8.5.13) | ✅ | ✅ |
| **8.4** (8.4.28) | ✅ | ✅ |
| **8.3** (8.3.37) | ✅ | ✅ |
| **8.2** (8.2.36) | ✅ | ✅ |

每个版本支持发行版：`trixie` / `bookworm` / `alpine3.24` / `alpine3.23`（共 120 个变体）。
<!-- VERSION-MATRIX-END -->

## 扩展版本

<!-- EXT-VERSIONS-START -->
- `igbinary/igbinary` — stable: **3.2.17RC1** ｜ pre-release: 3.2.17RC1
- `msgpack/msgpack-php` — stable: **v3.0.1**
- `php-ds/ext-ds` — stable: **v2.0.0**
- `phpredis/phpredis` — stable: **6.3.0** ｜ pre-release: 6.4.0RC1
- `swoole/swoole` — stable: **v6.3.0** ｜ pre-release: v6.3.0-rc2
- `swow/swow-extension` — stable: **v1.6.2** ｜ pre-release: v2.0.0-alpha.3
<!-- EXT-VERSIONS-END -->

变体说明：

- `cli` — 标准 CLI（默认）
- `zts` — PHP 线程安全（ZTS）
- `swoole` — 内置 [Swoole](https://github.com/swoole/swoole-src) 扩展
- `swow` — 内置 [Swow](https://github.com/swow/swow) 扩展
- `thread` — **ZTS PHP + Swoole 线程模式**（`--enable-swoole-thread`，单进程多线程）
- **注意**：`8.6-rc` 目前只提供 `cli` 与 `zts`；`swoole` / `swow` / `thread` 尚无可编译于 PHP 8.6 的上游版本，等适配后再加入（见 `.github/workflows/check-86-extensions.yml` 的每周检查）

## 镜像 Tag 矩阵

> 镜像大小与安全扫描（CRITICAL/HIGH）由 CI 自动更新（每次推送快照 + 每 8 小时安全扫描）。

<!-- TAG-MATRIX-START -->
### cli
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| latest | 8.6 | trixie | 2026-11-21T09:56:18Z | 183.9 MB | 179.5 MB | 1/121 |
| 8.6-cli-trixie | 8.6 | trixie | 2026-11-21T09:56:18Z | 183.9 MB | 179.5 MB | 1/121 |
| 8.6-cli-alpine3.24 | 8.6 | alpine3.24 | 2026-11-21T10:04:00Z | 45.8 MB | 45.4 MB | 0/0 |
| 8.6-cli-alpine3.23 | 8.6 | alpine3.23 | 2026-11-21T09:56:52Z | 42.8 MB | 42.8 MB | 0/0 |
| 8.6-cli-bookworm | 8.6 | bookworm | 2026-11-21T10:05:38Z | 170.4 MB | 164.6 MB | 4/123 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-11-21T10:01:02Z | 44.3 MB | 44.4 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-11-21T10:05:31Z | 42.2 MB | 41.8 MB | 0/0 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-11-21T09:58:04Z | 182.7 MB | 178.2 MB | 1/121 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-11-21T09:58:05Z | 173.8 MB | 163.4 MB | 4/123 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-11-21T10:09:23Z | 43.4 MB | 43.4 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-11-21T10:00:37Z | 41 MB | 40.8 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-11-21T10:07:55Z | 194.9 MB | 179.7 MB | 1/121 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-11-21T10:10:19Z | 171.8 MB | 161.4 MB | 4/123 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-11-21T10:03:02Z | 41.1 MB | 41.1 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-11-21T10:11:45Z | 38.5 MB | 38.5 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-11-21T10:08:25Z | 193.4 MB | 176.6 MB | 1/121 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-11-21T09:55:42Z | 164 MB | 158.3 MB | 4/123 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-11-21T10:03:19Z | 40.5 MB | 40.6 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-11-21T09:57:08Z | 38.1 MB | 38 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-11-21T10:04:40Z | 191.6 MB | 176 MB | 1/121 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-11-21T10:06:46Z | 163.3 MB | 157.7 MB | 4/123 |
### zts
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.6-zts-alpine3.24 | 8.6 | alpine3.24 | 2026-11-21T09:56:57Z | 51.9 MB | 51.4 MB | 0/0 |
| 8.6-zts-alpine3.23 | 8.6 | alpine3.23 | 2026-11-21T10:00:45Z | 48.8 MB | 48.8 MB | 0/0 |
| 8.6-zts-trixie | 8.6 | trixie | 2026-11-21T09:58:10Z | 194.1 MB | 179.6 MB | 1/121 |
| 8.6-zts-bookworm | 8.6 | bookworm | 2026-11-21T09:57:45Z | 168.7 MB | 164.7 MB | 4/123 |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-11-21T10:01:20Z | 50.6 MB | 50.2 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-11-21T09:56:41Z | 48.1 MB | 47.6 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-11-21T09:56:42Z | 182.1 MB | 178.3 MB | 1/121 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-11-21T09:56:08Z | 167.5 MB | 163.4 MB | 4/123 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-11-21T10:11:19Z | 48.6 MB | 48.2 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-11-21T09:55:15Z | 46 MB | 45.7 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-11-21T09:55:29Z | 190.9 MB | 176.4 MB | 1/121 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-11-21T10:05:20Z | 165.6 MB | 161.6 MB | 4/123 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-11-21T10:10:09Z | 45.1 MB | 45.1 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-11-21T10:12:15Z | 42.9 MB | 42.6 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-11-21T09:56:42Z | 186.7 MB | 173.4 MB | 1/121 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-11-21T10:04:55Z | 162.5 MB | 158.4 MB | 4/123 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-11-21T10:07:38Z | 44.8 MB | 44.5 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-11-21T10:09:08Z | 42.2 MB | 41.9 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-11-21T10:03:41Z | 179.9 MB | 176.1 MB | 1/121 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-11-21T10:05:48Z | 163.4 MB | 157.8 MB | 4/123 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-11-26T06:04:29Z | 48.4 MB | 48.2 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-11-26T06:03:42Z | 48.6 MB | 48.4 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-11-26T06:03:36Z | 183.2 MB | 183 MB | 1/71 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-11-26T06:05:15Z | 167.2 MB | 167.1 MB | 4/124 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-11-26T06:05:50Z | 47.3 MB | 47.1 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-11-26T06:05:54Z | 47.5 MB | 47.3 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-11-26T06:05:44Z | 184.7 MB | 184.4 MB | 1/71 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-11-26T06:05:43Z | 165.4 MB | 165.2 MB | 4/124 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-11-26T06:07:18Z | 45 MB | 44.8 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-11-26T06:08:49Z | 45.2 MB | 45 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-11-26T06:08:03Z | 181.5 MB | 181.3 MB | 1/71 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-11-26T06:08:27Z | 162.3 MB | 162.1 MB | 4/124 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-11-26T06:10:56Z | 44.5 MB | 44.3 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-11-26T06:11:48Z | 44.6 MB | 44.5 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-11-26T06:08:54Z | 180.6 MB | 180.6 MB | 1/71 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-11-26T06:09:34Z | 161.7 MB | 161.4 MB | 4/124 |
### thread
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-11-26T06:03:42Z | 54.2 MB | 54 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-11-26T06:05:41Z | 54.2 MB | 54.2 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-11-26T06:03:07Z | 183.5 MB | 183.2 MB | 1/71 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-11-26T06:03:05Z | 167.3 MB | 167.3 MB | 4/124 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-11-26T06:05:01Z | 52.3 MB | 52.1 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-11-26T06:05:26Z | 52.5 MB | 52.3 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-11-26T06:03:38Z | 181.3 MB | 181.3 MB | 1/71 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-11-26T06:03:25Z | 165.6 MB | 165.4 MB | 4/124 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-11-26T06:08:22Z | 48.9 MB | 48.9 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-11-26T06:09:36Z | 49.1 MB | 49.1 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-11-26T06:08:07Z | 178.4 MB | 178.2 MB | 1/71 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-11-26T06:07:59Z | 162.3 MB | 162.2 MB | 4/124 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-11-26T06:11:08Z | 48.5 MB | 48.3 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-11-26T06:11:11Z | 48.7 MB | 48.5 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-11-26T06:08:41Z | 181.1 MB | 180.8 MB | 1/71 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-11-26T06:10:40Z | 161.8 MB | 161.6 MB | 4/124 |
### swow
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-11-26T06:02:49Z | 46.8 MB | 46.8 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-11-26T06:02:52Z | 47.1 MB | 47 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-11-26T06:02:41Z | 190.7 MB | 187.7 MB | 1/71 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-11-26T06:02:24Z | 165.5 MB | 165.5 MB | 4/124 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-11-26T06:05:50Z | 45.9 MB | 45.8 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-11-26T06:05:13Z | 46 MB | 46 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-11-26T06:05:35Z | 183 MB | 182.9 MB | 1/71 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-11-26T06:04:29Z | 163.7 MB | 163.6 MB | 4/124 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-11-26T06:07:02Z | 43.5 MB | 43.5 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-11-26T06:05:00Z | 43.7 MB | 43.7 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-11-26T06:07:21Z | 179.8 MB | 179.7 MB | 1/71 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-11-26T06:07:31Z | 160.6 MB | 160.4 MB | 4/124 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-11-26T06:09:36Z | 43 MB | 42.9 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-11-26T06:10:16Z | 43.1 MB | 43.1 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-11-26T06:08:32Z | 179.2 MB | 179.1 MB | 1/71 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-11-26T06:09:01Z | 160 MB | 159.8 MB | 4/124 |
<!-- TAG-MATRIX-END -->

## 镜像标签规则

```
<php>[-<变体>][-<发行版>]
```

- 默认发行版省略：`8.5`、`8.5-swoole`
- 指定发行版：`8.5-swoole-bookworm`、`8.5-cli-alpine3.24`
- 完整版本号：`8.5.9-swoole`
- 阿里云镜像同规则：`crpi-...aliyuncs.com/eracloud/php:8.5-swoole`

## 快速开始

### docker run

```sh
docker run --rm -it ghcr.io/era-cloud/php:8.5-swoole php -v
docker run --rm -it ghcr.io/era-cloud/php:8.5-swow php -m
docker run --rm -it ghcr.io/era-cloud/php:8.5-thread php --ri swoole
```

### docker compose

`compose.yml` 包含应用服务（`gateway` / `api`，默认启动）与依赖服务（`pgsql` / `redis` / `mysql` / `rabbit`，需 `--profile deps` 启用）。

```sh
# 只启动应用（gateway + api）
docker compose up -d

# 应用 + 依赖（pgsql/redis/mysql/rabbit）
docker compose --profile deps up -d

# 只启动单个依赖
docker compose --profile deps up -d pgsql

# 查看调试日志
docker compose logs -f --tail 100
```

> 使用前先修改 `deploy/.env`（依赖服务环境变量）并准备 `deploy/caddy/.env`、`deploy/caddy/Caddyfile`。

## 配置

- `deploy/.env` — 依赖服务（pgsql/redis/mysql）的环境变量
- `deploy/caddy/Caddyfile` — gateway（Caddy）反向代理配置
- `deploy/caddy/.env` — gateway（Caddy）环境变量
- `deploy/mysql/my.cnf`、`deploy/redis/redis.conf`、`deploy/rabbitmq/rabbitmq.conf` — 依赖服务配置文件
- `deploy/` 下 `postgresql/`、`mysql/`、`redis/data/`、`rabbitmq/`、`runtime/`、`dist/` — 运行时数据/构建产物（compose 卷挂载）
- `app-src` 挂载 — `api` 服务将当前目录挂载到容器 `/app-src`，用于 hyperf/swoole 应用开发
- `api` 环境变量：
  - `NODE` — 节点名称（默认 `dev`）
  - `XDEBUG_CONFIG` — Xdebug 调试配置（`client_host` / `start_with_request`）
- 时区：容器内固定 `Asia/Shanghai`

## 特性

- 基于 Docker 官方 php 镜像构建，镜像体积小、安全、稳定
- **swoole** — 协程/常驻内存/高并发（`8.5-thread` 提供单进程多线程模式）
- **swow** — 协程引擎（ssl/curl/pdo-pgsql 默认启用）
- **redis 增强** — igbinary/msgpack 序列化、lz4/zstd 压缩（`Available serializers => php, json, igbinary, msgpack`）
- 扩展安装全面采用 **PIE**（PECL 已移除）
- 内置 composer（含国内镜像源配置）
- 提供国内 Aliyun ACR 加速
- 镜像更新及时，不定期同步上游 Docker Official Image

## 构建

```sh
# 更新版本（抓取 php.net 最新版本）
./versions.sh

# 应用模板生成所有 Dockerfile
./apply-templates.sh

# 生成 stackbrew library（CI 用）
./generate-stackbrew-library.sh
```

- `versions.json` — 各版本/变体定义
- `Dockerfile-linux.template` — Dockerfile 模板（修改后运行 `./apply-templates.sh` 重新生成）
- CI：`Release`（版本检查/同步）→ `Build and Push`（构建/测试/推送 ghcr + ACR）

## 维护者

- [@长久同学](https://github.com/littlezo)
- [@Era Cloud](https://github.com/era-cloud)
- [@Era Meta](https://github.com/meta-era)

fork 自 [Docker "Official Image"](https://github.com/docker-library/php)

## License

[MIT](LICENSE)
