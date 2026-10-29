#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/../.."

start='<!-- TAG-MATRIX-START -->'
end='<!-- TAG-MATRIX-END -->'

block="$(
	jq -r '
		def verid: (.version | sub("-rc$"; "") | split(".") | map(tonumber)) | .[0]*10000 + .[1]*100 + (.[2] // 0);
		def distroid: if .distro=="alpine3.24" then 0 elif .distro=="alpine3.23" then 1 elif .distro=="trixie" then 2 else 3 end;
		def rowfields:
			[
				.tag,
				.version,
				.distro,
				(.built_at // "待构建"),
				(if .size then (((.size / 1024 / 1024) * 10 | round) / 10 | tostring) + " MB" else "待扫描" end),
				(if .pull_size then (((.pull_size / 1024 / 1024) * 10 | round) / 10 | tostring) + " MB" else "待扫描" end),
				(if (.critical == null and .high == null) then "待扫描" else ((.critical // 0 | tostring) + "/" + (.high // 0 | tostring)) end)
			] | @tsv;

		( [.[] | select(.version | endswith("-rc") | not) | .version] | max ) as $lv
		| [ .[] | select(.version == $lv and .variant == "cli" and (.distro | startswith("alpine") | not)) ][0] as $latest
		| (
			["cli", "zts", "swoole", "thread", "swow"][] as $g
			| select( [.[].variant] | index($g) )
			| [
				"### " + $g,
				"tag\tPHP\t发行版\t构建时间\t镜像大小\t拉取大小\t安全扫描 CRITICAL/HIGH",
				"---\t---\t---\t---\t---\t---\t---",
				(
					if $g == "cli" then
						(
							[ $latest | .tag = "latest" ]
							+ [ $latest ]
							+ ( [ .[] | select(.variant == "cli" and .version == $lv and .tag != $latest.tag) ] | sort_by(distroid) )
							+ ( [ .[] | select(.variant == "cli" and .version != $lv) ] | sort_by(-verid, distroid) )
						)
					else
						( [ .[] | select(.variant == $g) ] | sort_by(-verid, distroid) )
					end
					| map(rowfields)
				)
			] | flatten[] | select(. != null)
		)
	' .image-metrics.json
)"

formatted="$(
	printf '%s\n' "$block" | while IFS= read -r line; do
		case "$line" in
			"### "*)
				printf '%s\n' "$line"
				;;
			*$'\t'*)
				printf '| %s |\n' "$(printf '%s' "$line" | sed 's/\t/ | /g')"
				;;
			*)
				printf '%s\n' "$line"
				;;
		esac
	done
)"

replace_block() { # <start-marker> <end-marker> <content>
	awk -v s="$1" -v e="$2" -v b="$3" '
		$0 == s { print; print b; in_block = 1; next }
		$0 == e { in_block = 0; print; next }
		in_block { next }
		{ print }
	' README.md > README.md.tmp && mv README.md.tmp README.md
}

replace_block "$start" "$end" "$formatted"
echo "updated README tag matrix"

# PHP 徽章：取自 versions.json 里所有仍在维护的版本
badge="$(
	jq -r '
		to_entries
		| map(select(.value))
		| map(.key)
		| sort
		| join("%20%7C%20")
	' versions.json
)"
replace_block '<!-- PHP-BADGE-START -->' '<!-- PHP-BADGE-END -->' \
	"[![PHP](https://img.shields.io/badge/PHP-${badge}-777BB4)](https://www.php.net/)"
echo "updated README php badge"

# 版本矩阵：每个版本支持哪些变体（cli / zts / swoole / swow / thread）
matrix="$(
	jq -r '
		def verid: (.value.version | sub("[a-zA-Z-].*$"; "") | split(".") | map(tonumber)) | .[0]*10000 + .[1]*100 + (.[2] // 0);
		[ to_entries[] | select(.value) ] as $all
		| [ "cli", "zts", "swoole", "swow", "thread" ] as $canon
		| ( [ $all[].value.variants[] | split("/")[1] ] | unique ) as $present
		| ( $canon | map(. as $c | select($present | index($c))) ) as $cols
		| (
			"| PHP | " + ($cols | join(" | ")) + " |",
			"|" + ([ range(0; ($cols | length) + 1) | "-----" ] | join("|")) + "|",
			(
				$all
				| sort_by(-verid)[]
				| "| **" + .key + "** (" + .value.version + ")"
					+ (if (.key | endswith("-rc")) then " · 预发布" else "" end)
					+ " |"
					+ ([ $cols[] as $c
						| if (.value.variants | any(endswith("/" + $c))) then " ✅ |" else " — |" end ] | join(""))
			),
			"",
			"每个版本支持发行版：" + (
				[ "trixie", "bookworm", "alpine3.24", "alpine3.23" ] as $canonSuites
				| [ $all[].value.variants[] | split("/")[0] ] | unique as $presentSuites
				| [ $canonSuites[] | select($presentSuites | index(.)) ]
				| map("`" + . + "`") | join(" / ")
			)
				+ "（共 " + ($all | map(.value.variants | length) | add | tostring) + " 个变体）。"
		)
	' versions.json
)"
replace_block '<!-- VERSION-MATRIX-START -->' '<!-- VERSION-MATRIX-END -->' "$matrix"
echo "updated README version matrix"
