# PHP Docker Images — era-cloud/php

[![Release](https://img.shields.io/github/actions/workflow/status/era-cloud/php/release.yml?branch=main&label=Release)](https://github.com/era-cloud/php/actions/workflows/release.yml)
[![Build and Push](https://img.shields.io/github/actions/workflow/status/era-cloud/php/ci.yml?branch=main&label=Build%20and%20Push)](https://github.com/era-cloud/php/actions/workflows/ci.yml)
[![Security Scan](https://img.shields.io/github/actions/workflow/status/era-cloud/php/security-scan.yml?branch=main&label=Security%20Scan)](https://github.com/era-cloud/php/actions/workflows/security-scan.yml)
[![License](https://img.shields.io/github/license/era-cloud/php)](https://github.com/era-cloud/php/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/era-cloud/php)](https://github.com/era-cloud/php/commits/main)
[![PHP](https://img.shields.io/badge/PHP-8.2%20%7C%208.3%20%7C%208.4%20%7C%208.5-777BB4)](https://www.php.net/)
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

| PHP | cli | zts | swoole | swow | thread |
|-----|-----|-----|--------|------|--------|
| **8.5** (8.5.9) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.4** (8.4.24) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.3** (8.3.33) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **8.2** (8.2.33) | ✅ | ✅ | ✅ | ✅ | ✅ |

每个版本支持发行版：`trixie` / `bookworm` / `alpine3.24` / `alpine3.23`（共 80 个变体）。

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
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| latest | 8.5 | trixie | 2026-08-10T19:27:31Z | 592.8 MB | 103/381 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-08-10T19:27:31Z | 592.8 MB | 103/381 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-08-10T19:42:34Z | 148.5 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-08-10T19:44:31Z | 148.2 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-08-10T19:27:43Z | 591.7 MB | 208/885 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-08-10T19:52:53Z | 123.2 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-08-10T19:30:04Z | 122.9 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-08-10T19:50:38Z | 563 MB | 103/381 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-08-10T19:27:27Z | 561.8 MB | 208/885 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-08-10T19:49:37Z | 119.1 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-08-10T19:50:16Z | 118.8 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-08-10T19:26:44Z | 556.2 MB | 103/381 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-08-10T19:39:02Z | 555 MB | 208/885 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-08-10T20:05:13Z | 112.6 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-08-10T20:04:46Z | 112.3 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-08-10T19:50:37Z | 548.6 MB | 103/381 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-08-10T19:59:56Z | 547.4 MB | 208/885 |
### zts
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-08-10T19:30:52Z | 173.9 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-08-10T19:31:04Z | 173.6 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-08-10T19:51:45Z | 592.8 MB | 103/381 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-08-10T19:38:46Z | 591.7 MB | 208/885 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-08-10T19:29:49Z | 142.5 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-08-10T19:42:27Z | 142.2 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-08-10T19:43:01Z | 563.2 MB | 103/381 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-08-10T19:27:12Z | 562 MB | 208/885 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-08-10T19:59:43Z | 135.6 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-08-10T19:51:55Z | 135.3 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-08-10T19:49:23Z | 556.4 MB | 103/381 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-08-10T19:52:23Z | 555.2 MB | 208/885 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-08-10T20:02:56Z | 128 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-08-10T20:04:01Z | 127.7 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-08-10T19:52:12Z | 548.7 MB | 103/381 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-08-10T20:08:21Z | 547.6 MB | 208/885 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-08-10T19:30:43Z | 457.1 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-08-10T19:34:50Z | 443.8 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-08-10T19:31:39Z | 661.4 MB | 120/415 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-08-10T19:40:59Z | 601.3 MB | 218/909 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-08-10T20:03:40Z | 447.7 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-08-10T19:51:58Z | 434.4 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-08-10T19:42:03Z | 651.9 MB | 120/415 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-08-10T19:30:54Z | 591.7 MB | 218/909 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-08-10T19:55:40Z | 444.9 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-08-10T20:02:27Z | 431.6 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-08-10T19:50:45Z | 649.1 MB | 120/415 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-08-10T20:01:39Z | 589 MB | 218/909 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-08-10T20:07:54Z | 442.3 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-08-10T20:02:44Z | 429 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-08-10T19:42:17Z | 646.5 MB | 120/415 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-08-10T20:04:10Z | 586.4 MB | 218/909 |
### thread
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-08-10T19:41:33Z | 457.4 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-08-10T19:49:10Z | 444.1 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-08-10T19:50:46Z | 661.7 MB | 120/415 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-08-10T19:42:37Z | 601.6 MB | 218/909 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-08-10T19:56:10Z | 448 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-08-10T20:05:17Z | 434.7 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-08-10T19:31:08Z | 652.2 MB | 120/415 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-08-10T19:31:14Z | 592.1 MB | 218/909 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-08-10T19:33:07Z | 445.3 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-08-10T19:46:03Z | 431.9 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-08-10T19:30:23Z | 649.4 MB | 120/415 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-08-10T19:54:15Z | 589.3 MB | 218/909 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-08-10T20:04:50Z | 442.7 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-08-10T20:05:05Z | 429.3 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-08-10T20:00:56Z | 646.8 MB | 120/415 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-08-10T20:04:17Z | 586.7 MB | 218/909 |
### swow
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-08-10T19:39:44Z | 470.3 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-08-10T19:42:07Z | 456.3 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-08-10T19:40:47Z | 650.1 MB | 120/411 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-08-10T19:55:16Z | 587.6 MB | 217/904 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-08-10T19:53:55Z | 461 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-08-10T19:29:31Z | 446.9 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-08-10T19:30:59Z | 640.6 MB | 120/411 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-08-10T19:30:31Z | 578.1 MB | 217/904 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-08-10T19:44:23Z | 458.2 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-08-10T20:02:38Z | 444.1 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-08-10T19:40:56Z | 637.9 MB | 120/411 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-08-10T19:56:04Z | 575.4 MB | 217/904 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-08-10T20:12:34Z | 455.6 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-08-10T20:04:55Z | 441.6 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-08-10T19:40:21Z | 635.3 MB | 120/411 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-08-10T20:05:20Z | 572.8 MB | 217/904 |
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
