#!/usr/bin/env bash
# 判断某个变体是否需要重建。
#
# 依据：变体目录自上次成功构建（记录在 .build-state.json）以来是否有改动。
# 只看变体目录本身：Dockerfile 是模板渲染产物，docker-php-* 也被 apply-templates.sh
# 复制进目录，所以"目录没变"即"渲染结果没变"，改模板不会连坐所有变体。
#
# 分层特例：扩展层的 Dockerfile 只有 `FROM 自家 base 的短别名`，
# base 变了（PHP 小版本升级等）扩展镜像也得重建，因此把 base 变体目录一起纳入判断。
#
# 用法：variant-changed.sh <变体目录> <变体名> [state 文件]
# 输出：写入 $GITHUB_OUTPUT 的 changed=，并在日志里打印 last/paths/changed。
set -Eeuo pipefail

dir="${1:?variant directory required}"
name="${2:?variant name required}"
state="${3:-.build-state.json}"

last="$(jq -r --arg n "$name" '.[$n] // empty' "$state" 2>/dev/null || true)"

paths="$dir"
from="$(awk 'toupper($1) == "FROM" { print $2; exit }' "$dir/Dockerfile")"
case "$from" in
'ghcr.io/era-cloud/php:'*)
	suite="$(basename "$(dirname "$dir")")"
	verdir="$(dirname "$(dirname "$dir")")"
	base_variant="$(sed -E 's#.*-(cli|zts)-[^-]+$#\1#' <<<"$from")"
	if [ -d "$verdir/$suite/$base_variant" ]; then
		paths="$paths $verdir/$suite/$base_variant"
	fi
	;;
esac

changed='true'
if [ -n "$last" ] && git diff --quiet "$last"..HEAD -- $paths; then
	changed='false'
fi

echo "last=$last paths=$paths changed=$changed"
if [ -n "${GITHUB_OUTPUT:-}" ]; then
	echo "changed=$changed" >>"$GITHUB_OUTPUT"
fi
