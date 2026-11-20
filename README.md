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

## 镜像源

```sh
# ghcr.io
docker pull ghcr.io/era-cloud/php:8.5-swoole

# 国内 Aliyun ACR
docker pull crpi-ae6l51vlbqurnd6c.cn-chengdu.personal.cr.aliyuncs.com/eracloud/php:8.5-swoole
```

## 版本矩阵

<!-- VERSION-MATRIX-START -->
| PHP | cli | zts | swoole | swow | thread |
|-----|-----|-----|-----|-----|-----|
| **8.6** (8.6.0) | ✅ | ✅ | — | — | — |
| **8.5** (8.5.13) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.4** (8.4.28) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.3** (8.3.37) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.2** (8.2.36) | ✅ | ✅ | ✅ | ✅ | ✅ |

每个版本支持发行版：`trixie` / `bookworm` / `alpine3.24` / `alpine3.23`（共 88 个变体）。
<!-- VERSION-MATRIX-END -->

## 扩展版本

<!-- EXT-VERSIONS-START -->
- `igbinary/igbinary` — stable: **3.2.17RC1** ｜ pre-release: 3.2.17RC1
- `msgpack/msgpack-php` — stable: **v3.0.1**
- `php-ds/ext-ds` — stable: **v2.0.0**
- `phpredis/phpredis` — stable: **6.3.0** ｜ pre-release: 6.3.0RC1
- `swoole/swoole` — stable: **v6.2.6** ｜ pre-release: v6.3.0-rc2
- `swow/swow-extension` — stable: **v1.6.2**
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
| latest | 8.6 | trixie | 2026-11-20T10:16:26Z | 165.1 MB | 160.7 MB | 1/121 |
| 8.6-cli-trixie | 8.6 | trixie | 2026-11-20T10:16:26Z | 165.1 MB | 160.7 MB | 1/121 |
| 8.6-cli-alpine3.24 | 8.6 | alpine3.24 | 2026-11-20T10:17:12Z | 39.8 MB | 39.8 MB | 0/0 |
| 8.6-cli-alpine3.23 | 8.6 | alpine3.23 | 2026-11-20T10:21:02Z | 37.7 MB | 37.3 MB | 0/0 |
| 8.6-cli-bookworm | 8.6 | bookworm | 2026-11-20T10:15:02Z | 173.2 MB | 162.9 MB | 3/123 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T05:11:36Z | 36 MB | 36 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T05:05:26Z | 33.6 MB | 33.6 MB | 0/0 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-11-20T05:00:57Z | 163.9 MB | 159.5 MB | 1/121 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-11-20T05:02:38Z | 167.5 MB | 161.8 MB | 3/123 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T05:02:03Z | 35 MB | 35 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T05:22:38Z | 32.5 MB | 32.6 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-11-20T05:01:10Z | 171 MB | 157.6 MB | 1/121 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-11-20T05:16:52Z | 170.2 MB | 159.9 MB | 3/123 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T05:23:27Z | 32.7 MB | 32.8 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T05:12:29Z | 30.3 MB | 30.4 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-11-20T05:08:04Z | 158.4 MB | 154.6 MB | 1/121 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-11-20T05:14:12Z | 168.7 MB | 156.8 MB | 3/123 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T05:32:35Z | 32.2 MB | 32.3 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T05:27:33Z | 29.8 MB | 29.8 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-11-20T05:16:06Z | 157.7 MB | 154 MB | 1/121 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-11-20T05:29:46Z | 161.8 MB | 156.2 MB | 3/123 |
### zts
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.6-zts-alpine3.24 | 8.6 | alpine3.24 | 2026-11-20T10:18:41Z | 45.7 MB | 45.8 MB | 0/0 |
| 8.6-zts-alpine3.23 | 8.6 | alpine3.23 | 2026-11-20T10:16:11Z | 43.7 MB | 43.3 MB | 0/0 |
| 8.6-zts-trixie | 8.6 | trixie | 2026-11-20T10:15:46Z | 174.7 MB | 160.7 MB | 1/121 |
| 8.6-zts-bookworm | 8.6 | bookworm | 2026-11-20T10:16:32Z | 168.7 MB | 162.9 MB | 3/123 |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T05:14:49Z | 41.8 MB | 41.8 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T05:03:45Z | 39.4 MB | 39.4 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-11-20T05:16:35Z | 164 MB | 159.6 MB | 1/121 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-11-20T05:10:58Z | 173.9 MB | 161.8 MB | 3/123 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T05:11:17Z | 40.2 MB | 39.9 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T05:10:41Z | 37.8 MB | 37.5 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-11-20T05:09:47Z | 161.6 MB | 157.8 MB | 1/121 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-11-20T05:21:41Z | 170.3 MB | 160 MB | 3/123 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T05:11:40Z | 36.8 MB | 36.8 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T05:15:18Z | 34.7 MB | 34.4 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-11-20T05:12:22Z | 159 MB | 154.7 MB | 1/121 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-11-20T05:17:23Z | 162.5 MB | 156.9 MB | 3/123 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T05:29:40Z | 36.4 MB | 36.2 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T10:43:50Z | 33.7 MB | 33.8 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-11-20T05:14:27Z | 167.4 MB | 154.1 MB | 1/121 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-11-20T05:28:24Z | 160.4 MB | 156.3 MB | 3/123 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T05:24:32Z | 44.4 MB | 44.4 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T05:09:52Z | 42 MB | 42 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-11-20T05:05:04Z | 187.2 MB | 172.5 MB | 1/121 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-11-20T05:05:37Z | 173.2 MB | 161 MB | 4/123 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T05:27:59Z | 43.8 MB | 43.4 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T05:24:13Z | 41.1 MB | 41 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-11-20T05:04:32Z | 185.1 MB | 171.4 MB | 1/121 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-11-20T05:03:05Z | 171.7 MB | 159.9 MB | 4/123 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T05:22:51Z | 41.2 MB | 41.1 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T05:20:51Z | 38.6 MB | 38.6 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-11-20T05:14:35Z | 174.6 MB | 169.2 MB | 1/121 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-11-20T05:27:09Z | 168.2 MB | 157.6 MB | 4/123 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T05:33:33Z | 40.7 MB | 40.6 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T05:29:23Z | 38.2 MB | 38.1 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-11-20T05:10:49Z | 183.3 MB | 168.6 MB | 1/121 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-11-20T05:32:03Z | 168.9 MB | 157.1 MB | 4/123 |
### thread
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T05:19:28Z | 45.1 MB | 44.6 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T05:07:11Z | 42.7 MB | 42.1 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-11-20T05:23:16Z | 187.3 MB | 172.7 MB | 1/121 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-11-20T05:06:08Z | 165.3 MB | 161.1 MB | 4/123 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T05:20:32Z | 43.9 MB | 43.5 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T05:26:03Z | 41.3 MB | 41.1 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-11-20T05:05:24Z | 186.6 MB | 171.6 MB | 1/121 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-11-20T05:07:46Z | 170.4 MB | 160.1 MB | 4/123 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T05:30:39Z | 41.6 MB | 41.2 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T05:11:09Z | 38.7 MB | 38.8 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-11-20T05:02:38Z | 174.8 MB | 169.3 MB | 1/121 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-11-20T05:22:37Z | 168.1 MB | 157.8 MB | 4/123 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T05:30:20Z | 41 MB | 40.7 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T10:24:04Z | 38.4 MB | 38.2 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-11-20T05:31:39Z | 182.1 MB | 168.7 MB | 1/121 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-11-20T05:32:33Z | 167.8 MB | 157.2 MB | 4/123 |
### swow
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T05:06:13Z | 44.1 MB | 43.6 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T05:06:18Z | 41.1 MB | 41.2 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-11-20T05:12:24Z | 184.9 MB | 171.5 MB | 1/121 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-11-20T05:26:19Z | 170.5 MB | 160 MB | 4/123 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T05:05:55Z | 42.6 MB | 42.6 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T05:24:38Z | 40.2 MB | 40.1 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-11-20T05:21:46Z | 183.9 MB | 170.5 MB | 1/121 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-11-20T05:03:57Z | 169.3 MB | 158.9 MB | 4/123 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T05:24:16Z | 40.3 MB | 40.3 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T05:22:42Z | 37.9 MB | 37.8 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-11-20T05:16:04Z | 181.9 MB | 168.2 MB | 1/121 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-11-20T05:14:14Z | 162.1 MB | 156.6 MB | 4/123 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T05:30:10Z | 39.9 MB | 39.7 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T05:31:16Z | 37.6 MB | 37.3 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-11-20T05:20:36Z | 173 MB | 167.6 MB | 1/121 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-11-20T05:28:40Z | 160.1 MB | 156 MB | 4/123 |
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
