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
- `phpredis/phpredis` — stable: **6.3.0** ｜ pre-release: 6.3.0RC1
- `swoole/swoole` — stable: **v6.2.6** ｜ pre-release: v6.3.0-rc2
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
| latest | 8.6 | trixie | 2026-11-20T12:33:47Z | 174.6 MB | 160.7 MB | 1/121 |
| 8.6-cli-trixie | 8.6 | trixie | 2026-11-20T12:33:47Z | 174.6 MB | 160.7 MB | 1/121 |
| 8.6-cli-alpine3.24 | 8.6 | alpine3.24 | 2026-11-20T12:35:53Z | 40.2 MB | 39.8 MB | 0/0 |
| 8.6-cli-alpine3.23 | 8.6 | alpine3.23 | 2026-11-20T12:39:41Z | 37.3 MB | 37.3 MB | 0/0 |
| 8.6-cli-bookworm | 8.6 | bookworm | 2026-11-20T12:34:10Z | 166.9 MB | 162.9 MB | 3/123 |
| 8.5-cli-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T12:47:11Z | 38.9 MB | 39 MB | 0/0 |
| 8.5-cli-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T12:37:57Z | 36.8 MB | 36.4 MB | 0/0 |
| 8.5-cli-trixie | 8.5 | trixie | 2026-11-20T12:49:26Z | 173.4 MB | 159.5 MB | 1/121 |
| 8.5-cli-bookworm | 8.5 | bookworm | 2026-11-20T12:34:08Z | 173.8 MB | 161.8 MB | 3/123 |
| 8.4-cli-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T12:37:57Z | 38.2 MB | 37.9 MB | 0/0 |
| 8.4-cli-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T12:57:23Z | 35.4 MB | 35.4 MB | 0/0 |
| 8.4-cli-trixie | 8.4 | trixie | 2026-11-20T12:53:27Z | 171 MB | 157.6 MB | 1/121 |
| 8.4-cli-bookworm | 8.4 | bookworm | 2026-11-20T12:51:46Z | 164 MB | 159.9 MB | 3/123 |
| 8.3-cli-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T12:56:23Z | 35.9 MB | 35.7 MB | 0/0 |
| 8.3-cli-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T12:55:06Z | 33.3 MB | 33.1 MB | 0/0 |
| 8.3-cli-trixie | 8.3 | trixie | 2026-11-20T12:54:29Z | 158.9 MB | 154.6 MB | 1/121 |
| 8.3-cli-bookworm | 8.3 | bookworm | 2026-11-20T12:50:34Z | 168.7 MB | 156.8 MB | 3/123 |
| 8.2-cli-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T13:01:27Z | 35.3 MB | 35.2 MB | 0/0 |
| 8.2-cli-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T13:09:15Z | 32.6 MB | 32.6 MB | 0/0 |
| 8.2-cli-trixie | 8.2 | trixie | 2026-11-20T12:58:47Z | 158.2 MB | 154 MB | 1/121 |
| 8.2-cli-bookworm | 8.2 | bookworm | 2026-11-20T13:02:57Z | 166.6 MB | 156.2 MB | 3/123 |
### zts
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.6-zts-alpine3.24 | 8.6 | alpine3.24 | 2026-11-20T12:40:56Z | 46.3 MB | 45.8 MB | 0/0 |
| 8.6-zts-alpine3.23 | 8.6 | alpine3.23 | 2026-11-20T12:34:38Z | 43.8 MB | 43.3 MB | 0/0 |
| 8.6-zts-trixie | 8.6 | trixie | 2026-11-20T12:58:21Z | 174 MB | 160.7 MB | 1/121 |
| 8.6-zts-bookworm | 8.6 | bookworm | 2026-11-20T12:34:08Z | 175 MB | 162.9 MB | 3/123 |
| 8.5-zts-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T12:42:06Z | 44.7 MB | 44.7 MB | 0/0 |
| 8.5-zts-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T12:36:30Z | 42.1 MB | 42.2 MB | 0/0 |
| 8.5-zts-trixie | 8.5 | trixie | 2026-11-20T12:35:17Z | 173.6 MB | 159.6 MB | 1/121 |
| 8.5-zts-bookworm | 8.5 | bookworm | 2026-11-20T12:43:29Z | 173.9 MB | 161.8 MB | 3/123 |
| 8.4-zts-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T12:37:49Z | 42.7 MB | 42.8 MB | 0/0 |
| 8.4-zts-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T12:50:42Z | 40.2 MB | 40.3 MB | 0/0 |
| 8.4-zts-trixie | 8.4 | trixie | 2026-11-20T12:45:23Z | 171.1 MB | 157.7 MB | 1/121 |
| 8.4-zts-bookworm | 8.4 | bookworm | 2026-11-20T12:42:27Z | 165.6 MB | 160 MB | 3/123 |
| 8.3-zts-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T12:55:37Z | 40.1 MB | 39.7 MB | 0/0 |
| 8.3-zts-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T13:00:20Z | 37.5 MB | 37.2 MB | 0/0 |
| 8.3-zts-trixie | 8.3 | trixie | 2026-11-20T12:56:16Z | 168 MB | 154.7 MB | 1/121 |
| 8.3-zts-bookworm | 8.3 | bookworm | 2026-11-20T12:46:07Z | 167.2 MB | 156.9 MB | 3/123 |
| 8.2-zts-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T13:04:50Z | 39.1 MB | 39.1 MB | 0/0 |
| 8.2-zts-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T15:07:20Z | 36.9 MB | 36.6 MB | 0/0 |
| 8.2-zts-trixie | 8.2 | trixie | 2026-11-20T13:02:32Z | 157.9 MB | 154.1 MB | 1/121 |
| 8.2-zts-bookworm | 8.2 | bookworm | 2026-11-20T13:05:54Z | 168.2 MB | 156.3 MB | 3/123 |
### swoole
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swoole-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T12:42:43Z | 47.3 MB | 47.3 MB | 0/0 |
| 8.5-swoole-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T12:48:48Z | 44.9 MB | 44.8 MB | 0/0 |
| 8.5-swoole-trixie | 8.5 | trixie | 2026-11-20T13:00:36Z | 176.8 MB | 172.5 MB | 1/121 |
| 8.5-swoole-bookworm | 8.5 | bookworm | 2026-11-20T12:45:41Z | 165.3 MB | 161 MB | 4/123 |
| 8.4-swoole-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T12:46:25Z | 46.2 MB | 46.3 MB | 0/0 |
| 8.4-swoole-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T12:54:12Z | 43.8 MB | 43.7 MB | 0/0 |
| 8.4-swoole-trixie | 8.4 | trixie | 2026-11-20T12:51:56Z | 176.6 MB | 171.5 MB | 1/121 |
| 8.4-swoole-bookworm | 8.4 | bookworm | 2026-11-20T12:55:42Z | 165.6 MB | 159.9 MB | 4/123 |
| 8.3-swoole-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T12:42:23Z | 44.2 MB | 44 MB | 0/0 |
| 8.3-swoole-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T13:05:27Z | 41.6 MB | 41.4 MB | 0/0 |
| 8.3-swoole-trixie | 8.3 | trixie | 2026-11-20T12:50:47Z | 183.8 MB | 169.2 MB | 1/121 |
| 8.3-swoole-bookworm | 8.3 | bookworm | 2026-11-20T12:49:27Z | 161.8 MB | 157.6 MB | 4/123 |
| 8.2-swoole-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T13:11:07Z | 43.6 MB | 43.5 MB | 0/0 |
| 8.2-swoole-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T13:13:52Z | 41.1 MB | 40.8 MB | 0/0 |
| 8.2-swoole-trixie | 8.2 | trixie | 2026-11-20T13:10:03Z | 173.7 MB | 168.6 MB | 1/121 |
| 8.2-swoole-bookworm | 8.2 | bookworm | 2026-11-20T13:06:40Z | 167.5 MB | 157.1 MB | 4/123 |
### thread
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-thread-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T12:40:43Z | 47.7 MB | 47.5 MB | 0/0 |
| 8.5-thread-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T12:40:04Z | 45.3 MB | 44.9 MB | 0/0 |
| 8.5-thread-trixie | 8.5 | trixie | 2026-11-20T13:01:07Z | 186 MB | 172.7 MB | 1/121 |
| 8.5-thread-bookworm | 8.5 | bookworm | 2026-11-20T12:48:38Z | 173 MB | 161.1 MB | 4/123 |
| 8.4-thread-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T12:39:48Z | 46.6 MB | 46.4 MB | 0/0 |
| 8.4-thread-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T12:49:07Z | 43.8 MB | 43.9 MB | 0/0 |
| 8.4-thread-trixie | 8.4 | trixie | 2026-11-20T12:46:46Z | 185 MB | 171.6 MB | 1/121 |
| 8.4-thread-bookworm | 8.4 | bookworm | 2026-11-20T12:59:32Z | 164.3 MB | 160.1 MB | 4/123 |
| 8.3-thread-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T12:59:19Z | 44.5 MB | 44.1 MB | 0/0 |
| 8.3-thread-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T13:01:19Z | 41.9 MB | 41.5 MB | 0/0 |
| 8.3-thread-trixie | 8.3 | trixie | 2026-11-20T12:37:17Z | 183 MB | 169.3 MB | 1/121 |
| 8.3-thread-bookworm | 8.3 | bookworm | 2026-11-20T12:56:44Z | 163.5 MB | 157.8 MB | 4/123 |
| 8.2-thread-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T13:06:19Z | 43.5 MB | 43.6 MB | 0/0 |
| 8.2-thread-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T15:09:10Z | 41.1 MB | 41 MB | 0/0 |
| 8.2-thread-trixie | 8.2 | trixie | 2026-11-20T13:09:06Z | 172.6 MB | 168.7 MB | 1/121 |
| 8.2-thread-bookworm | 8.2 | bookworm | 2026-11-20T13:07:44Z | 162.9 MB | 157.2 MB | 4/123 |
### swow
| tag | PHP | 发行版 | 构建时间 | 压缩大小 | 拉取大小 | 安全扫描 CRITICAL/HIGH |
| --- | --- | --- | --- | --- | --- | --- |
| 8.5-swow-alpine3.24 | 8.5 | alpine3.24 | 2026-11-20T12:45:43Z | 46.6 MB | 46.6 MB | 0/0 |
| 8.5-swow-alpine3.23 | 8.5 | alpine3.23 | 2026-11-20T12:36:10Z | 44.4 MB | 44 MB | 0/0 |
| 8.5-swow-trixie | 8.5 | trixie | 2026-11-20T12:35:45Z | 175.4 MB | 171.5 MB | 1/121 |
| 8.5-swow-bookworm | 8.5 | bookworm | 2026-11-20T12:53:34Z | 172.1 MB | 160 MB | 4/123 |
| 8.4-swow-alpine3.24 | 8.4 | alpine3.24 | 2026-11-20T12:38:49Z | 45.6 MB | 45.5 MB | 0/0 |
| 8.4-swow-alpine3.23 | 8.4 | alpine3.23 | 2026-11-20T12:47:42Z | 43.3 MB | 42.9 MB | 0/0 |
| 8.4-swow-trixie | 8.4 | trixie | 2026-11-20T12:57:03Z | 184.2 MB | 170.5 MB | 1/121 |
| 8.4-swow-bookworm | 8.4 | bookworm | 2026-11-20T13:02:51Z | 164.6 MB | 158.9 MB | 4/123 |
| 8.3-swow-alpine3.24 | 8.3 | alpine3.24 | 2026-11-20T12:49:09Z | 43.2 MB | 43.2 MB | 0/0 |
| 8.3-swow-alpine3.23 | 8.3 | alpine3.23 | 2026-11-20T13:08:03Z | 40.9 MB | 40.6 MB | 0/0 |
| 8.3-swow-trixie | 8.3 | trixie | 2026-11-20T12:58:26Z | 183.1 MB | 168.2 MB | 1/121 |
| 8.3-swow-bookworm | 8.3 | bookworm | 2026-11-20T12:48:27Z | 162.2 MB | 156.6 MB | 4/123 |
| 8.2-swow-alpine3.24 | 8.2 | alpine3.24 | 2026-11-20T13:07:06Z | 42.7 MB | 42.7 MB | 0/0 |
| 8.2-swow-alpine3.23 | 8.2 | alpine3.23 | 2026-11-20T13:03:54Z | 40.2 MB | 40 MB | 0/0 |
| 8.2-swow-trixie | 8.2 | trixie | 2026-11-20T13:03:51Z | 182.6 MB | 167.6 MB | 1/121 |
| 8.2-swow-bookworm | 8.2 | bookworm | 2026-11-20T13:06:56Z | 166.4 MB | 156 MB | 4/123 |
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
