# PHP Docker Images — era-cloud/php

[![Release](https://img.shields.io/github/actions/workflow/status/era-cloud/php/release.yml?branch=main&label=Release)](https://github.com/era-cloud/php/actions/workflows/release.yml)
[![Build and Push](https://img.shields.io/github/actions/workflow/status/era-cloud/php/ci.yml?branch=main&label=Build%20and%20Push)](https://github.com/era-cloud/php/actions/workflows/ci.yml)
[![Security Scan](https://img.shields.io/github/actions/workflow/status/era-cloud/php/security-scan.yml?branch=main&label=Security%20Scan)](https://github.com/era-cloud/php/actions/workflows/security-scan.yml)
[![License](https://img.shields.io/github/license/era-cloud/php)](https://github.com/era-cloud/php/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/era-cloud/php)](https://github.com/era-cloud/php/commits/main)
<!-- PHP-BADGE-START -->
[![PHP](https://img.shields.io/badge/PHP-8.2%20%7C%208.3%20%7C%208.4%20%7C%208.5%20%7C%208.6-rc-777BB4)](https://www.php.net/)
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
| **8.6-rc** (8.6.0RC7) · 预发布 | ✅ | ✅ | — | — | — |
| **8.5** (8.5.12) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.4** (8.4.27) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.3** (8.3.36) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.2** (8.2.35) | ✅ | ✅ | ✅ | ✅ | ✅ |

每个版本支持发行版：`trixie` / `bookworm` / `alpine3.24` / `alpine3.23`（共 88 个变体）。
<!-- VERSION-MATRIX-END -->

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
| latest | 8.5 | trixie | 2026-11-17T16:52:50Z | 163.9 MB | 159.4 MB | 1/121 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-11-17T16:52:50Z | 163.9 MB | 159.4 MB | 1/121 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-11-17T16:55:59Z | 33.6 MB | 33.6 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-11-17T16:56:22Z | 33.6 MB | 33.6 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-11-17T17:04:07Z | 167.5 MB | 161.7 MB | 3/123 |
| 8.6-rc-cli-alpine3.24 | 8.6-rc | alpine3.24 | 2026-11-17T17:19:07Z | 37.8 MB | 37.5 MB | 0/0 |
| 8.6-rc-cli-alpine3.23 | 8.6-rc | alpine3.23 | 2026-11-17T16:59:39Z | 37.6 MB | 37.3 MB | 0/0 |
| 8.6-rc-cli-trixie | 8.6-rc | trixie | 2026-11-17T16:54:04Z | 164.5 MB | 160.7 MB | 1/121 |
| 8.6-rc-cli-bookworm | 8.6-rc | bookworm | 2026-11-17T16:53:05Z | 166.9 MB | 162.9 MB | 3/123 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-11-17T17:20:52Z | 32.6 MB | 32.6 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-11-17T17:03:26Z | 32.5 MB | 32.6 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-11-17T17:13:14Z | 171.3 MB | 157.6 MB | 1/121 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-11-17T17:15:07Z | 171.7 MB | 159.8 MB | 3/123 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-11-17T17:08:24Z | 30.6 MB | 30.4 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-11-17T17:05:05Z | 30.6 MB | 30.4 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-11-17T17:21:43Z | 168 MB | 154.6 MB | 1/121 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-11-17T17:20:06Z | 160.9 MB | 156.8 MB | 3/123 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-11-17T17:29:14Z | 30 MB | 29.9 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-11-17T17:31:13Z | 30 MB | 29.8 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-11-17T17:25:59Z | 157.7 MB | 153.9 MB | 1/121 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-11-17T17:37:15Z | 168 MB | 156.2 MB | 3/123 |
### zts
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.6-rc-zts-alpine3.24 | 8.6-rc | alpine3.24 | 2026-11-17T17:00:04Z | 43.5 MB | 43.5 MB | 0/0 |
| 8.6-rc-zts-alpine3.23 | 8.6-rc | alpine3.23 | 2026-11-17T17:06:22Z | 43.8 MB | 43.3 MB | 0/0 |
| 8.6-rc-zts-trixie | 8.6-rc | trixie | 2026-11-17T16:54:17Z | 174.1 MB | 160.7 MB | 1/121 |
| 8.6-rc-zts-bookworm | 8.6-rc | bookworm | 2026-11-17T16:53:18Z | 168.7 MB | 162.9 MB | 3/123 |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-11-17T17:13:55Z | 39.9 MB | 39.4 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-11-17T17:03:37Z | 39.3 MB | 39.3 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-11-17T16:55:24Z | 172.9 MB | 159.5 MB | 1/121 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-11-17T16:55:27Z | 173.8 MB | 161.8 MB | 3/123 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-11-17T16:55:49Z | 37.5 MB | 37.5 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-11-17T17:04:38Z | 37.7 MB | 37.4 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-11-17T17:11:06Z | 171 MB | 157.7 MB | 1/121 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-11-17T16:54:47Z | 171.8 MB | 159.9 MB | 3/123 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-11-17T17:15:52Z | 34.7 MB | 34.5 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-11-17T17:34:39Z | 34.3 MB | 34.4 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-11-17T17:13:18Z | 158.5 MB | 154.7 MB | 1/121 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-11-17T17:20:53Z | 168.8 MB | 156.9 MB | 3/123 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-11-17T17:34:45Z | 33.8 MB | 33.8 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-11-17T17:37:33Z | 34.1 MB | 33.8 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-11-17T17:27:29Z | 157.9 MB | 154 MB | 1/121 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-11-17T17:27:15Z | 160.4 MB | 156.3 MB | 3/123 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-11-17T17:03:36Z | 42.2 MB | 42 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-11-17T17:20:03Z | 42.3 MB | 41.9 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-11-17T16:57:17Z | 176.3 MB | 172.5 MB | 1/121 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-11-17T16:56:18Z | 171.5 MB | 160.9 MB | 4/125 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-11-17T17:23:11Z | 41.1 MB | 41 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-11-17T17:18:21Z | 41.2 MB | 40.9 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-11-17T17:12:00Z | 176.9 MB | 171.4 MB | 1/121 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-11-17T18:32:10Z | 163.9 MB | 159.9 MB | 4/125 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-11-17T17:22:29Z | 39.1 MB | 38.7 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-11-17T17:29:37Z | 38.6 MB | 38.6 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-11-17T17:04:29Z | 174.6 MB | 169.2 MB | 1/121 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-11-17T17:07:54Z | 168 MB | 157.6 MB | 4/125 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-11-17T17:29:17Z | 38.5 MB | 38.2 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-11-17T17:31:23Z | 38.3 MB | 38 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-11-17T17:30:24Z | 173.7 MB | 168.6 MB | 1/121 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-11-17T17:28:22Z | 161.3 MB | 157.1 MB | 4/125 |
### thread
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-11-17T17:03:05Z | 42.3 MB | 42.2 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-11-17T17:11:26Z | 42.2 MB | 42.1 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-11-17T17:16:16Z | 186.5 MB | 172.6 MB | 1/121 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-11-17T16:59:43Z | 167 MB | 161 MB | 4/125 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-11-17T17:18:41Z | 41.3 MB | 41.1 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-11-17T17:19:02Z | 41.5 MB | 41 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-11-17T17:23:28Z | 176.7 MB | 171.6 MB | 1/121 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-11-17T17:10:08Z | 165.5 MB | 160 MB | 4/125 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-11-17T17:22:40Z | 39.1 MB | 38.8 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-11-17T17:28:51Z | 39.1 MB | 38.7 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-11-17T17:20:24Z | 173.1 MB | 169.3 MB | 1/121 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-11-17T17:08:29Z | 162 MB | 157.8 MB | 4/125 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-11-17T17:41:57Z | 38.6 MB | 38.3 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-11-17T17:31:56Z | 38.2 MB | 38.2 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-11-17T17:32:49Z | 172.5 MB | 168.7 MB | 1/121 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-11-17T17:27:09Z | 169 MB | 157.2 MB | 4/125 |
### swow
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-11-17T16:59:07Z | 41.7 MB | 41.2 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-11-17T16:57:38Z | 41.5 MB | 41.1 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-11-17T17:03:57Z | 176.5 MB | 171.5 MB | 1/121 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-11-17T17:05:46Z | 170.4 MB | 159.9 MB | 4/125 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-11-17T17:09:07Z | 40.5 MB | 40.2 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-11-17T17:18:24Z | 40.2 MB | 40.1 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-11-17T17:08:53Z | 185.4 MB | 170.4 MB | 1/121 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-11-17T17:14:40Z | 164.5 MB | 158.9 MB | 4/125 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-11-17T17:08:47Z | 38.1 MB | 37.9 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-11-17T17:30:18Z | 37.8 MB | 37.8 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-11-17T17:22:34Z | 172.3 MB | 168.2 MB | 1/121 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-11-17T17:13:34Z | 160.7 MB | 156.6 MB | 4/125 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-11-17T17:33:56Z | 37.4 MB | 37.4 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-11-17T17:36:19Z | 37.2 MB | 37.3 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-11-17T17:37:31Z | 172.6 MB | 167.6 MB | 1/121 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-11-17T17:31:47Z | 160.2 MB | 156 MB | 4/125 |
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
