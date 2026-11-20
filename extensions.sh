#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

# 维护 extensions.json：从 Packagist 取每个扩展的最新 stable / pre-release 版本，
# 再通过 GitHub API 把 tag 解析成 commit sha（PIE 按 pkg:tag 解析不可靠，但
# pkg:dev-<branch>#<sha> 可靠），供模板做可复现的 pin。
#
# 与 versions.sh 对 PHP 的更新逻辑一致：
#   - 有新版本就写回 extensions.json（随后 apply-templates 会把 ref 渲染进 Dockerfile）
#   - 跨大版本（6.x → 7.x）不自动升，只打 warning，需人工确认
#   - 预发布（-RC/-beta/-alpha）写入 rc 字段
#
# 用法：./extensions.sh [pkg...]

api="https://api.github.com"
# 优先用 gh CLI（带认证，避免 60/h 的匿名限流），否则退回 GITHUB_TOKEN，最后才匿名
gh_api() {
	local path="$1"
	if command -v gh > /dev/null && gh auth token > /dev/null 2>&1; then
		gh api "$path"
	elif [ -n "${GITHUB_TOKEN:-}" ]; then
		curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/$path"
	else
		curl -fsSL --retry 3 --retry-delay 3 --retry-all-errors "https://api.github.com/$path"
	fi
}

pkgs=( "$@" )
if [ "${#pkgs[@]}" -eq 0 ]; then
	pkgs=( $(jq -r 'keys[]' extensions.json) )
fi

current="$(< extensions.json)"

major_of() { echo "${1#v}" | sed -E 's/^([0-9]+).*/\1/'; }

resolve_ref() { # <pkg> <version> -> "dev-<branch>#<sha>"（失败则空）
	local pkg="$1" ver="$2" branch sha
	branch="$(gh_api "repos/$pkg" 2>/dev/null | jq -r '.default_branch // empty')" || return 0
	[ -n "$branch" ] || return 0
	sha="$(gh_api "repos/$pkg/commits/$ver" 2>/dev/null | jq -r '.sha // empty')" || return 0
	[ -n "$sha" ] || return 0
	echo "dev-$branch#$sha"
}

for pkg in "${pkgs[@]}"; do
	data="$(curl -fsSL --retry 5 --retry-delay 5 --retry-all-errors "https://repo.packagist.org/p2/${pkg}.json")" || {
		echo >&2 "warning: 无法获取 $pkg 的 Packagist 数据，跳过"
		continue
	}

	stable_ver="$(jq -r --arg p "$pkg" '
		[ .packages[$p][] | select(.version | test("-|[0-9](RC|rc|beta|alpha)") | not) ]
		| sort_by(.time) | last | .version // empty
	' <<<"$data")"
	rc_ver="$(jq -r --arg p "$pkg" '
		[ .packages[$p][] | select(.version | test("-|[0-9](RC|rc|beta|alpha)")) ]
		| sort_by(.time) | last | .version // empty
	' <<<"$data")"

	old_stable_ver="$(jq -r --arg p "$pkg" '.[$p].stable.version // empty' <<<"$current")"
	old_rc_ver="$(jq -r --arg p "$pkg" '.[$p].rc.version // empty' <<<"$current")"

	if [ -n "$stable_ver" ] && [ -n "$old_stable_ver" ] && [ "$(major_of "$stable_ver")" != "$(major_of "$old_stable_ver")" ]; then
		echo >&2 "warning: $pkg 出现跨大版本更新（$old_stable_ver -> $stable_ver），未自动升级，请人工确认"
		stable_ver="$old_stable_ver"
	fi

	# 有些包（如 igbinary）只发 RC 命名的版本，没有纯正式版：回退到最新版本
	if [ -z "$stable_ver" ] && [ -n "$rc_ver" ]; then
		stable_ver="$rc_ver"
		echo >&2 "notice: $pkg 无纯正式版，stable 回退到 $stable_ver"
	fi

	stable_ref=""
	if [ -z "$stable_ver" ]; then
		stable_ver="$old_stable_ver"
		echo >&2 "notice: $pkg 未找到可用版本，保留 $stable_ver"
	else
		stable_ref="$(resolve_ref "$pkg" "$stable_ver")"
	fi
	if [ -n "$stable_ver" ] && [ -z "$stable_ref" ]; then
		echo >&2 "warning: $pkg 无法解析 $stable_ver 的 commit，保持原值"
		stable_ver="$old_stable_ver"
		stable_ref="$(jq -r --arg p "$pkg" '.[$p].stable.ref // empty' <<<"$current")"
	fi

	rc_ref=""
	# swow 的 pre-release 发布在核心仓库 swow/swow（swow-extension 只有 v0.2.0-alpha.1），
	# 版本号取核心仓 tag，ref 指向 swow-extension 的 develop HEAD
	if [ "$pkg" = "swow/swow-extension" ]; then
		core_rc="$(gh_api "repos/swow/swow/tags?per_page=10" 2>/dev/null | jq -r '[.[].name | select(test("-"))] | sort | last // empty')"
		if [ -n "$core_rc" ]; then
			rc_ver="$core_rc"
			dev_sha="$(gh_api "repos/swow/swow-extension/commits/develop" 2>/dev/null | jq -r '.sha // empty')"
			if [ -n "$dev_sha" ]; then
				rc_ref="dev-develop#$dev_sha"
			fi
		fi
	fi

	if [ "$pkg" = "swow/swow-extension" ] && [ -n "$rc_ref" ]; then
		: # 已经用核心仓 tag + extension develop sha 组好，不再走 tag 解析
	elif [ -z "$rc_ver" ]; then
		rc_ver="$old_rc_ver"
	else
		rc_ref="$(resolve_ref "$pkg" "$rc_ver")"
	fi
	if [ -n "$rc_ver" ] && [ -z "$rc_ref" ]; then
		echo >&2 "warning: $pkg 无法解析 $rc_ver 的 commit，保持原值"
		rc_ver="$old_rc_ver"
		rc_ref="$(jq -r --arg p "$pkg" '.[$p].rc.ref // empty' <<<"$current")"
	fi

	if [ "$stable_ref" = "$(jq -r --arg p "$pkg" '.[$p].stable.ref // empty' <<<"$current")" ] \
		&& [ "$rc_ref" = "$(jq -r --arg p "$pkg" '.[$p].rc.ref // empty' <<<"$current")" ]; then
		echo "$pkg: 无变化（stable=${stable_ver:-none} rc=${rc_ver:-none}）"
		continue
	fi

	echo "$pkg: stable ${old_stable_ver:-none} -> ${stable_ver:-none} (${stable_ref:-none}); rc ${old_rc_ver:-none} -> ${rc_ver:-none} (${rc_ref:-none})"
	current="$(jq -c --arg p "$pkg" \
		--arg sv "$stable_ver" --arg sr "$stable_ref" \
		--arg rv "$rc_ver" --arg rr "$rc_ref" '
		.[$p] = {
			stable: (if $sv == "" then null else {version: $sv, ref: $sr} end),
			rc:     (if $rv == "" then null else {version: $rv, ref: $rr} end)
		}
	' <<<"$current")"
done

jq -S . <<<"$current" > extensions.json
echo "wrote extensions.json"
