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
| **8.6-rc** (8.6.0RC4) · 预发布 | ✅ | ✅ | — | — | — |
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

## 镜像 Tag 矩阵

> 镜像大小与安全扫描（CRITICAL/HIGH）由 CI 自动更新（每次推送快照 + 每 8 小时安全扫描）。

<!-- TAG-MATRIX-START -->
### cli
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| latest | 8.5 | trixie | 2026-10-29T13:14:46Z | 501.7 MB | 159.3 MB | 1/62 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-10-29T13:14:46Z | 501.7 MB | 159.3 MB | 1/62 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-10-29T12:49:17Z | 85.3 MB | 33.5 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-10-29T12:59:37Z | 85.2 MB | 33.4 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-10-29T12:48:26Z | 503 MB | 161.6 MB | 3/83 |
| 8.6-rc-cli-alpine3.24 | 8.6-rc | alpine3.24 | 2026-10-29T19:16:00Z | 89 MB | 37.3 MB | 0/0 |
| 8.6-rc-cli-alpine3.23 | 8.6-rc | alpine3.23 | 2026-10-29T19:20:23Z | 88.7 MB | 37.1 MB | 0/0 |
| 8.6-rc-cli-trixie | 8.6-rc | trixie | 2026-10-29T19:15:28Z | 505 MB | 160.5 MB | 1/62 |
| 8.6-rc-cli-bookworm | 8.6-rc | bookworm | 2026-10-29T19:14:42Z | 506.4 MB | 162.8 MB | 3/83 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-10-29T13:10:57Z | 76 MB | 32.5 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-10-29T12:57:53Z | 75.9 MB | 32.4 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-10-29T12:59:56Z | 487.9 MB | 157.4 MB | 1/62 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-10-29T13:10:42Z | 489.2 MB | 159.8 MB | 3/83 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-10-29T13:07:14Z | 73.4 MB | 30.3 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-10-29T13:02:59Z | 73.3 MB | 30.2 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-10-29T13:01:50Z | 482.5 MB | 154.4 MB | 1/62 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-10-29T13:15:08Z | 483.8 MB | 156.8 MB | 3/83 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-10-29T13:17:23Z | 70.8 MB | 29.7 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-10-29T13:22:10Z | 70.7 MB | 29.7 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-10-29T13:16:41Z | 479 MB | 153.8 MB | 1/62 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-10-29T13:24:24Z | 480.2 MB | 156.1 MB | 3/83 |
### zts
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.6-rc-zts-alpine3.24 | 8.6-rc | alpine3.24 | 2026-10-29T19:18:22Z | 115 MB | 43.3 MB | 0/0 |
| 8.6-rc-zts-alpine3.23 | 8.6-rc | alpine3.23 | 2026-10-29T19:20:41Z | 114.7 MB | 43.1 MB | 0/0 |
| 8.6-rc-zts-trixie | 8.6-rc | trixie | 2026-10-29T19:15:26Z | 505.1 MB | 160.5 MB | 1/62 |
| 8.6-rc-zts-bookworm | 8.6-rc | bookworm | 2026-10-29T19:15:22Z | 506.4 MB | 162.8 MB | 3/83 |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-10-29T12:52:26Z | 110.7 MB | 39.3 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-10-29T12:59:08Z | 110.6 MB | 39.2 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-10-29T12:56:26Z | 501.7 MB | 159.4 MB | 1/62 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-10-29T13:13:26Z | 503 MB | 161.7 MB | 3/83 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-10-29T13:02:35Z | 95.3 MB | 37.3 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-10-29T13:03:38Z | 95.2 MB | 37.3 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-10-29T13:07:33Z | 488.1 MB | 157.5 MB | 1/62 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-10-29T13:09:30Z | 489.4 MB | 159.9 MB | 3/83 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-10-29T13:00:51Z | 89.9 MB | 34.3 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-10-29T13:19:29Z | 89.8 MB | 34.3 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-10-29T12:47:01Z | 482.7 MB | 154.5 MB | 1/62 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-10-29T12:47:05Z | 484 MB | 156.9 MB | 3/83 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-10-29T13:24:54Z | 86.3 MB | 33.7 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-10-29T13:24:15Z | 86.2 MB | 33.6 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-10-29T13:20:32Z | 479.1 MB | 153.9 MB | 1/62 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-10-29T13:27:07Z | 480.4 MB | 156.2 MB | 3/83 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-10-29T12:53:59Z | 112.7 MB | 41.9 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-10-29T13:08:29Z | 112.5 MB | 41.8 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-10-29T12:51:44Z | 533.4 MB | 172.3 MB | 1/65 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-10-29T13:06:39Z | 498.6 MB | 160.9 MB | 4/83 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-10-29T13:17:48Z | 103.2 MB | 40.8 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-10-29T13:19:33Z | 103 MB | 40.7 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-10-29T13:12:23Z | 523.9 MB | 171.3 MB | 1/65 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-10-29T12:53:44Z | 489 MB | 159.8 MB | 4/83 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-10-29T13:15:58Z | 100.4 MB | 38.5 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-10-29T13:30:17Z | 100.2 MB | 38.5 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-10-29T13:14:20Z | 521.1 MB | 169 MB | 1/65 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-10-29T13:09:34Z | 486.2 MB | 157.5 MB | 4/83 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-10-29T13:28:11Z | 97.8 MB | 38 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-10-29T13:23:50Z | 97.6 MB | 37.9 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-10-29T13:29:11Z | 518.5 MB | 168.5 MB | 1/65 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-10-29T13:20:57Z | 483.6 MB | 157 MB | 4/83 |
### thread
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-10-29T13:21:33Z | 113 MB | 42 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-10-29T13:05:00Z | 112.8 MB | 41.9 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-10-29T12:53:27Z | 533.7 MB | 172.5 MB | 1/65 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-10-29T12:52:29Z | 498.9 MB | 161 MB | 4/83 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-10-29T13:08:36Z | 103.5 MB | 41 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-10-29T13:04:28Z | 103.4 MB | 40.9 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-10-29T13:17:04Z | 524.2 MB | 171.4 MB | 1/65 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-10-29T13:06:28Z | 489.4 MB | 159.9 MB | 4/83 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-10-29T13:22:28Z | 100.7 MB | 38.7 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-10-29T13:31:21Z | 100.5 MB | 38.6 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-10-29T12:58:46Z | 521.4 MB | 169.2 MB | 1/65 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-10-29T13:14:46Z | 486.5 MB | 157.7 MB | 4/83 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-10-29T13:28:20Z | 98.1 MB | 38.1 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-10-29T13:30:28Z | 97.9 MB | 38 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-10-29T13:32:06Z | 518.8 MB | 168.6 MB | 1/65 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-10-29T13:31:49Z | 483.9 MB | 157.1 MB | 4/83 |
### swow
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-10-29T12:55:35Z | 105 MB | 41.1 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-10-29T13:14:12Z | 104.8 MB | 41 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-10-29T12:50:28Z | 525.1 MB | 171.4 MB | 1/62 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-10-29T12:52:41Z | 489.7 MB | 159.8 MB | 4/83 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-10-29T13:18:19Z | 95.6 MB | 40.1 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-10-29T13:19:00Z | 95.4 MB | 40 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-10-29T13:05:58Z | 515.6 MB | 170.3 MB | 1/62 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-10-29T12:57:56Z | 480.3 MB | 158.8 MB | 4/83 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-10-29T12:53:53Z | 92.7 MB | 37.8 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-10-29T13:29:52Z | 92.5 MB | 37.7 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-10-29T13:04:24Z | 512.8 MB | 168 MB | 1/62 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-10-29T13:09:59Z | 477.4 MB | 156.5 MB | 4/83 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-10-29T13:28:17Z | 90.1 MB | 37.2 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-10-29T13:29:25Z | 90 MB | 37.1 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-10-29T13:21:18Z | 510.2 MB | 167.5 MB | 1/62 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-10-29T13:27:32Z | 474.8 MB | 156 MB | 4/83 |
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
