#!/usr/bin/env bash
set -Eeuo pipefail

# 本地快速验证脚本：按需挑几行执行即可（全量构建耗时很久）。
# 目录以 versions.json 为准；变体变动后请同步更新这里。

# 8.6 目前只有 cli / zts（swoole / swow / thread 尚无支持 8.6 的版本）
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.6-rc-cli-trixie' '8.6-rc/trixie/cli'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.6-rc-zts-trixie' '8.6-rc/trixie/zts'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.6-rc-cli-alpine' '8.6-rc/alpine3.24/cli'

# 8.5 全量变体代表
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-cli-trixie' '8.5/trixie/cli'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-swoole-trixie' '8.5/trixie/swoole'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-swow-trixie' '8.5/trixie/swow'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-thread-trixie' '8.5/trixie/thread'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-cli-alpine' '8.5/alpine3.24/cli'
