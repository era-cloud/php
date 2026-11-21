#!/usr/bin/env bash
set -Eeuo pipefail

declare -A aliases=(
	[8.6]='8 latest'
)

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

if [ "$#" -eq 0 ]; then
	versions="$(jq -r 'to_entries | map(if .value then .key | @sh else empty end) | join(" ")' versions.json)"
	eval "set -- $versions"
fi

# sort version numbers with highest first
IFS=$'\n'; set -- $(sort -rV <<<"$*"); unset IFS

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

getArches() {
	local repo="$1"; shift
	local officialImagesBase="${BASHBREW_LIBRARY:-https://github.com/docker-library/official-images/raw/HEAD/library}/"

	local parentRepoToArchesStr
	parentRepoToArchesStr="$(
		find -name 'Dockerfile' -exec awk -v officialImagesBase="$officialImagesBase" '
				toupper($1) == "FROM" && $2 !~ /^('"$repo"'|scratch|.*\/.*)(:|$)/ {
					printf "%s%s\n", officialImagesBase, $2
				}
			' '{}' + \
			| sort -u \
			| xargs -r bashbrew cat --format '["{{ .RepoName }}:{{ .TagName }}"]="{{ join " " .TagEntry.Architectures }}"'
	)"
	eval "declare -g -A parentRepoToArches=( $parentRepoToArchesStr )"
}
getArches 'php'

# 分层：扩展变体 FROM 自家 base 镜像（ghcr.io/era-cloud/php:<ver>-<cli|zts>-<suite>）。
# 这种自引用在 official-images 里查不到架构，这里先把每个 base 变体的 tag 映射到它真正的
# 上游父镜像（debian:trixie-slim / alpine:3.x）的架构列表，扩展变体再继承这份列表。
declare -A selfTagArches=()
selfRepo='ghcr.io/era-cloud/php'
for version; do
	export version
	variants="$(jq -r '.[env.version].variants // [] | map(@sh) | join(" ")' versions.json 2>/dev/null || true)"
	[ -n "$variants" ] || continue
	eval "vs=( $variants )"
	for dir in "${vs[@]}"; do
		[ -f "$version/$dir/Dockerfile" ] || continue
		parent="$(awk 'toupper($1) == "FROM" { print $2; exit }' "$version/$dir/Dockerfile")"
		case "$parent" in
		"$selfRepo":*) continue ;; # base 层不会是自引用
		esac
		selfTagArches["$version-${dir##*/}-${dir%%/*}"]="${parentRepoToArches[$parent]}"
	done
	unset vs variants
done

# 扩展版本维度（分层后的 tag 矩阵）。
# 「无 PHP 版本」的短 tag（swoole / swoole-6.2 …）只指向「最新可用 PHP 版本 + 最新 alpine suite」，
# 否则同一个 tag 会被多个版本重复声明。
declare -A latestVerForVariant=()
declare -A extTagsForVariant=()
declare -A extFullTagForVariant=()
for version; do
	export version
	variants="$(jq -r '.[env.version].variants // [] | map(@sh) | join(" ")' versions.json 2>/dev/null || true)"
	[ -n "$variants" ] || continue
	eval "vs=( $variants )"
	for dir in "${vs[@]}"; do
		variant="${dir##*/}"
		# 版本已按 sort -rV 降序，第一次见到即最新
		[ -n "${latestVerForVariant[$variant]:-}" ] || latestVerForVariant["$variant"]="$version"
	done
	unset vs variants
done

for variant in swoole swoole-rc swow swow-rc thread; do
	case "$variant" in
	swoole | swoole-rc | thread) extPkg='swoole/swoole' ;;
	swow | swow-rc) extPkg='swow/swow-extension' ;;
	esac
	if [ "${variant%-rc}" != "$variant" ]; then
		extVer="$(jq -r --arg p "$extPkg" '.[$p].rc.version // empty' extensions.json)"
	else
		extVer="$(jq -r --arg p "$extPkg" '.[$p].stable.version // empty' extensions.json)"
	fi
	extVer="${extVer#v}"
	[ -n "$extVer" ] || continue
	IFS=. read -r -a parts <<<"${extVer%%-*}"
	major="${parts[0]:-}"
	minor="$major${parts[1]:+.${parts[1]}}"
	full="$minor${parts[2]:+.${parts[2]}}"
	tags=()
	if [ "${variant%-rc}" != "$variant" ]; then
		# rc 轨只用「轨道 / major / major.minor」+ -rc 后缀（swoole-rc / swoole-6-rc / swoole-6.3-rc），
		# 完整身份（如 6.3.0-rc2）只进 OCI label
		stem="${variant%-rc}"
		[ -n "$major" ] && tags+=( "$stem-$major-rc" )
		[ -n "$parts[1]" ] && tags+=( "$stem-$minor-rc" )
		tags+=( "$variant" )
	else
		[ -n "$major" ] && tags+=( "$variant-$major" )
		[ -n "$parts[1]" ] && tags+=( "$variant-$minor" )
		[ -n "$parts[2]" ] && tags+=( "$variant-$full" )
		tags+=( "$variant" )
	fi
	extTagsForVariant["$variant"]="$(printf '%s\n' "${tags[@]}")"
	# 精确 pin 用：php 完整版本 + 扩展完整版本
	[ "${variant%-rc}" != "$variant" ] || extFullTagForVariant["$variant"]="$full"
done

cat <<-EOH
# this file is generated via https://github.com/era-cloud/php/blob/$(fileCommit "$self")/$self

Maintainers: @长久同学 <x@era-x.cn> (@era-x),
             @小小只同学 <x@era-x.wiki> (@era-x)
GitRepo: https://github.com/era-cloud/php.git
EOH

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

for version; do
	rcVersion="${version%-rc}"
	export version rcVersion

	if ! fullVersion="$(jq -er '.[env.version] | if . then .version else empty end' versions.json)"; then
		continue
	fi

	if [ "$rcVersion" != "$version" ] && rcFullVersion="$(jq -er '.[env.rcVersion] | if . then .version else empty end' versions.json)"; then
		# if this is a "-rc" release, let's make sure the release it contains isn't already GA (and thus something we should not publish anymore)
		latestVersion="$({ echo "$fullVersion"; echo "$rcFullVersion"; } | sort -V | tail -1)"
		if [[ "$fullVersion" == "$rcFullVersion"* ]] || [ "$latestVersion" = "$rcFullVersion" ]; then
			# "x.y.z-rc1" == x.y.z*
			continue
		fi
	fi

	variants="$(jq -r '.[env.version].variants | map(@sh) | join(" ")' versions.json)"
	eval "variants=( $variants )"

	versionAliases=(
		$fullVersion
		$version
		${aliases[$version]:-}
	)

	defaultDebianVariant="$(jq -r '
		.[env.version].variants
		| map(
			split("/")[0]
			| select(
				startswith("alpine")
				| not
			)
		)
		| .[0]
	' versions.json)"
	defaultAlpineVariant="$(jq -r '
		.[env.version].variants
		| map(
			split("/")[0]
			| select(
				startswith("alpine")
			)
		)
		| .[0]
	' versions.json)"

	for dir in "${variants[@]}"; do
		suite="$(dirname "$dir")" # "buster", etc
		variant="$(basename "$dir")" # "cli", etc
		dir="$version/$dir"
		[ -f "$dir/Dockerfile" ] || continue

		variantAliases=( "${versionAliases[@]/%/-$variant}" )
		variantAliases=( "${variantAliases[@]//latest-/}" )

		if [ "$variant" = 'cli' ]; then
			variantAliases+=( "${versionAliases[@]}" )
		fi

		suiteVariantAliases=( "${variantAliases[@]/%/-$suite}" )
		if [ "$suite" = "$defaultAlpineVariant" ] ; then
			variantAliases=( "${variantAliases[@]/%/-alpine}" )
		elif [ "$suite" != "$defaultDebianVariant" ]; then
			variantAliases=()
		fi
		variantAliases=( "${suiteVariantAliases[@]}" ${variantAliases[@]+"${variantAliases[@]}"} )
		variantAliases=( "${variantAliases[@]//latest-/}" )

		# 扩展版本维度（只对扩展层生效，base 的 cli/zts 没有）
		if [ -n "${extTagsForVariant[$variant]:-}" ]; then
			mapfile -t eTags <<<"${extTagsForVariant[$variant]}"
			ext=()
			# 无 PHP 版本：仅「该变体最新版本 + 最新 alpine suite」
			if [ "${latestVerForVariant[$variant]:-}" = "$version" ] && [ "$suite" = "$defaultAlpineVariant" ]; then
				ext+=( "${eTags[@]}" )
			fi
			for e in "${eTags[@]}"; do
				[ "$suite" = "$defaultDebianVariant" ] && ext+=( "$version-$e" )
				ext+=( "$version-$e-$suite" )
				[ "$suite" = "$defaultAlpineVariant" ] && ext+=( "$version-$e-alpine" )
			done
			# php 完整版本 + 扩展完整版本（精确 pin；rc 轨不生成）
			if [ -n "${extFullTagForVariant[$variant]:-}" ]; then
				e="${extFullTagForVariant[$variant]}"
				[ "$suite" = "$defaultDebianVariant" ] && ext+=( "$fullVersion-$variant-$e" )
				ext+=( "$fullVersion-$variant-$e-$suite" )
			fi
			variantAliases+=( "${ext[@]}" )
		fi

		# 去重（扩展版本维度会与原有别名重叠，例如 8.5-swoole；保留首次出现的顺序，主 tag 仍在最前）
		mapfile -t variantAliases < <(printf '%s\n' "${variantAliases[@]}" | awk '!seen[$0]++')

		variantParent="$(awk 'toupper($1) == "FROM" { print $2; exit }' "$dir/Dockerfile")"
		case "$variantParent" in
		"$selfRepo":*)
			# 扩展层：继承自家 base 变体的架构列表
			variantArches="${selfTagArches[${variantParent#"$selfRepo":}]}"
			;;
		*)
			variantArches="${parentRepoToArches[$variantParent]}"
			;;
		esac

		# php segfaults on arm32v6 for these pre-releases
		# https://github.com/docker-library/php/issues/1675
		if [[ "$suite" =~ 'alpine'* ]]; then
			if [[ "$fullVersion" == '8.6.0beta'* ]]; then
				variantArches="$(jq <<<"$variantArches" --raw-input --raw-output '
					split(" ") - [ "arm32v6" ]
					| join(" ")
				')"
			fi
		fi

		commit="$(dirCommit "$dir")"

		echo
		cat <<-EOE
			Tags: $(join ', ' "${variantAliases[@]}")
			Architectures: $(join ', ' $variantArches)
			GitCommit: $commit
			Directory: $dir
		EOE
	done
done