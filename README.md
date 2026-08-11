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
| latest | 8.5 | trixie | 2026-08-11T08:13:02Z | 499.3 MB | 17/41 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-08-11T08:13:02Z | 499.3 MB | 17/41 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T08:15:45Z | 83.2 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T08:28:36Z | 83.1 MB | 0/0 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-08-11T08:12:18Z | 501.6 MB | 19/44 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T08:30:17Z | 73.9 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T08:27:41Z | 73.8 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-08-11T08:12:39Z | 485.6 MB | 17/41 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-08-11T08:38:19Z | 487.8 MB | 19/44 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T08:12:12Z | 71.4 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T08:26:29Z | 71.2 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-08-11T08:20:25Z | 480.3 MB | 17/41 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-08-11T08:12:53Z | 482.5 MB | 19/44 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T08:44:39Z | 68.8 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T08:45:30Z | 68.7 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-08-11T08:12:20Z | 476.7 MB | 17/41 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-08-11T08:49:00Z | 478.9 MB | 19/44 |
### zts
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T08:23:27Z | 108.6 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T08:14:18Z | 108.5 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-08-11T08:13:25Z | 499.4 MB | 17/41 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-08-11T08:12:15Z | 501.6 MB | 19/44 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T08:23:04Z | 93.2 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T08:36:59Z | 93.1 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-08-11T08:19:42Z | 485.8 MB | 17/41 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-08-11T08:29:37Z | 488 MB | 19/44 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T08:35:43Z | 87.8 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T08:41:18Z | 87.7 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-08-11T08:22:41Z | 480.4 MB | 17/41 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-08-11T08:12:53Z | 482.6 MB | 19/44 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T08:43:42Z | 84.2 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T08:48:39Z | 84.1 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-08-11T08:39:05Z | 476.9 MB | 17/41 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-08-11T08:45:47Z | 479 MB | 19/44 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T08:20:32Z | 110.3 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T08:20:14Z | 110.1 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-08-11T08:16:59Z | 530.9 MB | 17/42 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-08-11T08:17:04Z | 497 MB | 20/44 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T08:19:57Z | 100.9 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T08:19:31Z | 100.7 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-08-11T08:41:15Z | 521.4 MB | 17/42 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-08-11T08:45:30Z | 487.4 MB | 20/44 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T08:42:33Z | 98.1 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T08:43:05Z | 97.9 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-08-11T08:35:10Z | 518.6 MB | 17/42 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-08-11T08:22:40Z | 484.7 MB | 20/44 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T08:54:34Z | 95.5 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T08:52:12Z | 95.3 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-08-11T08:39:25Z | 516.1 MB | 17/42 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-08-11T08:46:27Z | 482.1 MB | 20/44 |
### thread
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T08:44:40Z | 110.6 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T08:30:54Z | 110.4 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-08-11T08:17:05Z | 531.2 MB | 17/42 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-08-11T08:17:27Z | 497.3 MB | 20/44 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T08:45:55Z | 101.2 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T08:42:16Z | 101 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-08-11T08:15:33Z | 521.7 MB | 17/42 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-08-11T08:29:56Z | 487.7 MB | 20/44 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T08:26:53Z | 98.5 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T08:29:32Z | 98.2 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-08-11T08:33:24Z | 519 MB | 17/42 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-08-11T08:30:24Z | 485 MB | 20/44 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T08:47:44Z | 95.9 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T08:55:44Z | 95.7 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-08-11T08:52:57Z | 516.4 MB | 17/42 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-08-11T08:50:26Z | 482.4 MB | 20/44 |
### swow
| tag | PHP | 发行版 | 构建时间 | 镜像大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-08-11T08:33:57Z | 102.8 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-08-11T08:28:49Z | 102.6 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-08-11T08:34:57Z | 522.7 MB | 17/41 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-08-11T08:25:00Z | 488.3 MB | 20/44 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-08-11T08:29:26Z | 93.4 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-08-11T08:31:47Z | 93.2 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-08-11T08:41:33Z | 513.3 MB | 17/41 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-08-11T08:32:06Z | 478.8 MB | 20/44 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-08-11T08:30:16Z | 90.6 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-08-11T08:41:05Z | 90.4 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-08-11T08:23:47Z | 510.5 MB | 17/41 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-08-11T08:38:20Z | 476 MB | 20/44 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-08-11T08:47:40Z | 88.1 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-08-11T08:53:04Z | 87.8 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-08-11T08:33:48Z | 507.9 MB | 17/41 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-08-11T08:49:57Z | 473.5 MB | 20/44 |
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
