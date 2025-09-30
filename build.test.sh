#!/usr/bin/env bash
set -Eeuo pipefail

DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-rc-alpine' '8.5-rc/alpine3.22/cli'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-rc-swow-alpine' '8.5-rc/alpine3.22/swow'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.5-rc-swoole-alpine' '8.5-rc/alpine3.22/swoole'


DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.4-swoole-trixie' '8.4/trixie/swoole'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.4-swow-trixie' '8.4/trixie/swow'

DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.4-swoole-alpine' '8.4/alpine3.22/swoole'
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 --tag 'ghcr.io/era-cloud/php:8.4-swow-alpine' '8.4/alpine3.22/swow'