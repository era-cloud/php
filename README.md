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
| latest | 8.5 | trixie | 2026-08-11T16:04:22Z | 499.3 MB | 159 MB | 17/42 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-08-11T16:04:22Z | 499.3 MB | 159 MB | 17/42 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T16:19:44Z | 83.2 MB | 33.2 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T16:15:15Z | 83.1 MB | 33.1 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-08-11T16:04:14Z | 501.6 MB | 161.3 MB | 19/45 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T16:16:54Z | 73.9 MB | 32.2 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T16:06:36Z | 73.8 MB | 32.1 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-08-11T16:03:58Z | 485.6 MB | 157.1 MB | 17/42 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-08-11T16:03:20Z | 487.8 MB | 159.5 MB | 19/45 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T16:12:31Z | 71.4 MB | 30 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T16:12:36Z | 71.2 MB | 30 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-08-11T16:16:42Z | 480.3 MB | 154.2 MB | 17/42 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-08-11T16:04:06Z | 482.5 MB | 156.5 MB | 19/45 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T16:37:16Z | 68.8 MB | 29.5 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T16:37:46Z | 68.7 MB | 29.4 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-08-11T16:18:45Z | 476.7 MB | 153.6 MB | 17/42 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-08-11T16:37:38Z | 478.9 MB | 155.9 MB | 19/45 |
### zts
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T16:25:13Z | 108.6 MB | 38.9 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T16:12:10Z | 108.5 MB | 38.8 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-08-11T16:04:48Z | 499.4 MB | 159.1 MB | 17/42 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-08-11T17:08:19Z | 501.6 MB | 161.4 MB | 19/45 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T16:30:17Z | 93.2 MB | 37 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T16:21:49Z | 93.1 MB | 36.9 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-08-11T16:04:14Z | 485.8 MB | 157.2 MB | 17/42 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-08-11T09:40:34Z | 488 MB | 待扫描 | 19/44 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T16:17:58Z | 87.8 MB | 34 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T16:28:33Z | 87.7 MB | 34 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-08-11T16:03:46Z | 480.4 MB | 154.3 MB | 17/42 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-08-11T16:20:34Z | 482.6 MB | 156.6 MB | 19/45 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T16:35:54Z | 84.2 MB | 33.4 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T16:38:33Z | 84.1 MB | 33.4 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-08-11T16:14:17Z | 476.8 MB | 153.7 MB | 17/42 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-08-11T16:32:14Z | 479 MB | 156 MB | 19/45 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T16:21:05Z | 110.3 MB | 41.5 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T16:33:10Z | 110.1 MB | 41.4 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-08-11T16:17:21Z | 530.9 MB | 172 MB | 17/43 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-08-11T16:26:19Z | 497 MB | 160.5 MB | 20/45 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T16:29:51Z | 100.9 MB | 40.4 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T16:31:00Z | 100.7 MB | 40.4 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-08-11T16:32:29Z | 521.4 MB | 170.9 MB | 17/43 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-08-11T16:29:51Z | 487.4 MB | 159.5 MB | 20/45 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T16:14:59Z | 98.1 MB | 38.2 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T16:08:57Z | 97.9 MB | 38.1 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-08-11T16:28:14Z | 518.6 MB | 168.8 MB | 17/43 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-08-11T16:06:23Z | 484.7 MB | 157.3 MB | 20/45 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T16:43:49Z | 95.5 MB | 37.7 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T09:45:52Z | 95.3 MB | 待扫描 | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-08-11T16:25:31Z | 516.1 MB | 168.2 MB | 17/43 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-08-11T16:41:09Z | 482.1 MB | 156.7 MB | 20/45 |
### thread
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T16:11:23Z | 110.6 MB | 41.6 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T16:33:31Z | 110.4 MB | 41.5 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-08-11T16:08:52Z | 531.2 MB | 172.1 MB | 17/43 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-08-11T16:15:12Z | 497.3 MB | 160.6 MB | 20/45 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T16:11:10Z | 101.2 MB | 40.6 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T16:16:02Z | 101 MB | 40.5 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-08-11T16:35:00Z | 521.7 MB | 171.1 MB | 17/43 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-08-11T16:08:10Z | 487.7 MB | 159.6 MB | 20/45 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T16:19:42Z | 98.5 MB | 38.4 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T16:18:19Z | 98.2 MB | 38.3 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-08-11T16:33:10Z | 519 MB | 168.9 MB | 17/43 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-08-11T16:23:14Z | 485 MB | 157.4 MB | 20/45 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T16:39:54Z | 95.9 MB | 37.8 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T16:43:53Z | 95.7 MB | 37.7 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-08-11T16:41:29Z | 516.4 MB | 168.3 MB | 17/43 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-08-11T16:43:17Z | 482.4 MB | 156.8 MB | 20/45 |
### swow
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T16:23:03Z | 102.8 MB | 40.7 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T16:24:03Z | 102.6 MB | 40.6 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-08-11T16:07:55Z | 522.7 MB | 171 MB | 17/42 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-08-11T16:35:29Z | 488.3 MB | 159.5 MB | 20/45 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T16:31:17Z | 93.4 MB | 39.7 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T16:38:00Z | 93.2 MB | 39.6 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-08-11T16:29:31Z | 513.3 MB | 170 MB | 17/42 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-08-11T16:31:55Z | 478.8 MB | 158.5 MB | 20/45 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T16:24:53Z | 90.6 MB | 37.5 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T16:35:06Z | 90.4 MB | 37.4 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-08-11T16:15:52Z | 510.5 MB | 167.8 MB | 17/42 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-08-11T16:06:52Z | 476 MB | 156.3 MB | 20/45 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T16:35:51Z | 88.1 MB | 36.9 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T16:43:44Z | 87.8 MB | 36.9 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-08-11T16:06:32Z | 507.9 MB | 167.2 MB | 17/42 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-08-11T16:40:07Z | 473.5 MB | 155.7 MB | 20/45 |
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
