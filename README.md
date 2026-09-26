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
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| latest | 8.5 | trixie | 2026-09-26T02:43:08Z | 501.5 MB | 159.2 MB | 1/65 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-09-26T02:43:08Z | 501.5 MB | 159.2 MB | 1/65 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-09-26T02:45:50Z | 85.2 MB | 33.4 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-09-26T02:54:13Z | 85.1 MB | 33.3 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-09-26T02:43:13Z | 503.6 MB | 161.5 MB | 15/91 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-09-26T02:54:51Z | 75.9 MB | 32.4 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-09-26T03:06:03Z | 75.8 MB | 32.3 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-09-26T02:52:31Z | 487.7 MB | 157.3 MB | 1/65 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-09-26T02:57:44Z | 489.7 MB | 159.7 MB | 15/91 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-09-26T02:56:01Z | 73.3 MB | 30.2 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-09-26T03:09:41Z | 73.2 MB | 30.1 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-09-26T03:00:31Z | 482.4 MB | 154.3 MB | 1/65 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-09-26T03:01:16Z | 484.4 MB | 156.7 MB | 15/91 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-09-26T03:14:14Z | 70.7 MB | 29.7 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-09-26T03:18:22Z | 70.7 MB | 29.6 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-09-26T02:54:59Z | 478.8 MB | 153.7 MB | 1/65 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-09-26T03:15:07Z | 480.8 MB | 156.1 MB | 15/91 |
### zts
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-09-26T02:44:01Z | 110.6 MB | 39.1 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-09-26T02:44:16Z | 110.5 MB | 39 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-09-26T02:42:58Z | 501.5 MB | 159.3 MB | 1/65 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-09-26T02:52:56Z | 503.6 MB | 161.6 MB | 15/91 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-09-26T03:04:14Z | 95.2 MB | 37.2 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-09-26T02:44:51Z | 95.1 MB | 37.2 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-09-26T03:00:29Z | 487.9 MB | 157.4 MB | 1/65 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-09-26T02:41:45Z | 489.9 MB | 159.7 MB | 15/91 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-09-26T02:52:45Z | 89.7 MB | 34.2 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-09-26T02:47:53Z | 89.7 MB | 34.2 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-09-26T02:42:27Z | 482.5 MB | 154.4 MB | 1/65 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-09-26T02:57:36Z | 484.5 MB | 156.8 MB | 15/91 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-09-26T03:15:52Z | 86.2 MB | 33.6 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-09-26T03:13:27Z | 86.1 MB | 33.5 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-09-26T03:02:44Z | 478.9 MB | 153.8 MB | 1/65 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-09-26T03:11:32Z | 481 MB | 156.2 MB | 15/91 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-09-26T03:14:03Z | 112.3 MB | 41.7 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-09-26T02:58:00Z | 112.2 MB | 41.6 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-09-26T03:04:50Z | 533.1 MB | 172.1 MB | 1/68 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-09-26T02:44:51Z | 498.9 MB | 160.7 MB | 16/91 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-09-26T03:01:19Z | 102.9 MB | 40.6 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-09-26T03:01:23Z | 102.7 MB | 40.6 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-09-26T02:52:24Z | 523.5 MB | 171.1 MB | 1/68 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-09-26T03:05:00Z | 489.4 MB | 159.7 MB | 16/91 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-09-26T03:05:20Z | 100.1 MB | 38.4 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-09-26T03:10:54Z | 99.9 MB | 38.3 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-09-26T02:53:42Z | 520.7 MB | 168.9 MB | 1/68 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-09-26T03:05:19Z | 486.6 MB | 157.4 MB | 16/91 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-09-26T03:22:57Z | 97.5 MB | 37.9 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-09-26T03:15:25Z | 97.3 MB | 37.7 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-09-26T03:07:22Z | 518.2 MB | 168.3 MB | 1/68 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-09-26T03:13:43Z | 484 MB | 156.9 MB | 16/91 |
### thread
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-09-26T02:45:59Z | 112.6 MB | 41.8 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-09-26T02:50:12Z | 112.5 MB | 41.7 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-09-26T02:46:42Z | 533.4 MB | 172.3 MB | 1/68 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-09-26T03:03:06Z | 499.2 MB | 160.8 MB | 16/91 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-09-26T03:10:16Z | 103.2 MB | 40.8 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-09-26T03:07:59Z | 103 MB | 40.7 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-09-26T02:45:41Z | 523.9 MB | 171.3 MB | 1/68 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-09-26T02:58:47Z | 489.7 MB | 159.8 MB | 16/91 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-09-26T03:04:27Z | 100.4 MB | 38.5 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-09-26T02:53:42Z | 100.2 MB | 38.4 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-09-26T02:52:58Z | 521.1 MB | 169 MB | 1/68 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-09-26T03:03:07Z | 486.9 MB | 157.6 MB | 16/91 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-09-26T03:18:27Z | 97.8 MB | 38 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-09-26T03:18:43Z | 97.7 MB | 37.9 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-09-26T03:16:35Z | 518.5 MB | 168.4 MB | 1/68 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-09-26T03:19:22Z | 484.3 MB | 157 MB | 16/91 |
### swow
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-09-26T02:49:18Z | 104.8 MB | 41 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-09-26T02:58:53Z | 104.6 MB | 40.8 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-09-26T02:45:02Z | 524.9 MB | 171.2 MB | 1/65 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-09-26T03:08:59Z | 490.2 MB | 159.7 MB | 16/91 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-09-26T02:57:23Z | 95.4 MB | 39.9 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-09-26T02:44:17Z | 95.2 MB | 39.8 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-09-26T02:44:01Z | 515.4 MB | 170.2 MB | 1/65 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-09-26T03:11:19Z | 480.8 MB | 158.7 MB | 16/91 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-09-26T03:10:24Z | 92.6 MB | 37.6 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-09-26T02:46:31Z | 92.4 MB | 37.6 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-09-26T02:54:11Z | 512.6 MB | 167.9 MB | 1/65 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-09-26T02:45:36Z | 478 MB | 156.5 MB | 16/91 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-09-26T03:21:53Z | 90 MB | 37.1 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-09-26T03:14:54Z | 89.8 MB | 37 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-09-26T03:09:47Z | 510 MB | 167.4 MB | 1/65 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-09-26T03:15:17Z | 475.4 MB | 155.9 MB | 16/91 |
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
