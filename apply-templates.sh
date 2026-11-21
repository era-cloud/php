#!/usr/bin/env bash
set -Eeuo pipefail

[ -f versions.json ] # run "versions.sh" first
[ -f extensions.json ] # run "extensions.sh" first

# 扩展版本（commit-sha pin）：PIE 按 tag 解析不可靠，统一用 dev-<branch>#<sha>
export ext_msgpack="$(jq -r '.["msgpack/msgpack-php"].stable.ref' extensions.json)"
export ext_igbinary="$(jq -r '.["igbinary/igbinary"].stable.ref' extensions.json)"
export ext_ds="$(jq -r '.["php-ds/ext-ds"].stable.ref' extensions.json)"
export ext_redis="$(jq -r '.["phpredis/phpredis"].stable.ref' extensions.json)"
export ext_swoole="$(jq -r '.["swoole/swoole"].stable.ref' extensions.json)"
export ext_swoole_rc="$(jq -r '.["swoole/swoole"].rc.ref // empty' extensions.json)"
export ext_swow="$(jq -r '.["swow/swow-extension"].stable.ref' extensions.json)"
export ext_swow_rc="$(jq -r '.["swow/swow-extension"].rc.ref // empty' extensions.json)"

# 可读版本号（写进 OCI label，便于 docker inspect 追溯）
export ext_msgpack_ver="$(jq -r '.["msgpack/msgpack-php"].stable.version' extensions.json)"
export ext_igbinary_ver="$(jq -r '.["igbinary/igbinary"].stable.version' extensions.json)"
export ext_ds_ver="$(jq -r '.["php-ds/ext-ds"].stable.version' extensions.json)"
export ext_redis_ver="$(jq -r '.["phpredis/phpredis"].stable.version' extensions.json)"
export ext_swoole_ver="$(jq -r '.["swoole/swoole"].stable.version' extensions.json)"
export ext_swow_ver="$(jq -r '.["swow/swow-extension"].stable.version' extensions.json)"
export ext_swoole_rc_ver="$(jq -r '.["swoole/swoole"].rc.version // ""' extensions.json)"
export ext_swow_rc_ver="$(jq -r '.["swow/swow-extension"].rc.version // ""' extensions.json)"

jqt='.jq-template.awk'
if [ -n "${BASHBREW_SCRIPTS:-}" ]; then
	jqt="$BASHBREW_SCRIPTS/jq-template.awk"
elif [ "$BASH_SOURCE" -nt "$jqt" ]; then
	# https://github.com/docker-library/bashbrew/blob/master/scripts/jq-template.awk
	wget -qO "$jqt" 'https://raw.githubusercontent.com/docker-library/bashbrew/master/scripts/jq-template.awk'
fi

if [ "$#" -eq 0 ]; then
	versions="$(jq -r 'keys | map(@sh) | join(" ")' versions.json)"
	eval "set -- $versions"
fi

generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#

	EOH
}

for version; do
	export version
	# 防御：只允许操作 8.x 版本目录，避免误删 docs/ 等目录
	if [[ ! "$version" =~ ^8\.[0-9]+(-rc)?$ ]]; then
		echo >&2 "skip: '$version' 不是 PHP 版本目录"
		continue
	fi
	if [ -d $version ]; then
		rm -rf "$version"
    # echo "文件夹存在"
	fi

	if jq -e '.[env.version] | not' versions.json >/dev/null; then
		echo "deleting $version ..."
		continue
	fi

	variants="$(jq -r '.[env.version].variants | map(@sh) | join(" ")' versions.json)"
	eval "variants=( $variants )"

	for dir in "${variants[@]}"; do
		suite="$(dirname "$dir")"    # "buster", etc
		variant="$(basename "$dir")" # "cli", etc
		export suite variant

		alpineVer="${suite#alpine}" # "3.12", etc
		if [ "$suite" != "$alpineVer" ]; then
			from="alpine:$alpineVer"
		else
			from="debian:$suite-slim"
		fi
		export from alpineVer

		case "$variant" in
		*) cmd='["php", "-a"]' ;;
		esac
		export cmd

		echo "processing $version/$dir ..."
		mkdir -p "$version/$dir"
		echo "$version/$dir"
		echo $jqt
		{
			generated_warning
			gawk -f "$jqt" 'Dockerfile-linux.template'
		} >"$version/$dir/Dockerfile"

		cp -a \
			docker-php-entrypoint \
			docker-php-ext-* \
			docker-php-source \
			"$version/$dir/"

		cmd="$(jq <<<"$cmd" -r '.[0]')"
		if [ "$cmd" != 'php' ]; then
			sed -i -e 's! php ! '"$cmd"' !g' "$version/$dir/docker-php-entrypoint"
		fi
	done
done
