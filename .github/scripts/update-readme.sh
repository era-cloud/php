#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/../.."

start='<!-- TAG-MATRIX-START -->'
end='<!-- TAG-MATRIX-END -->'

block="$(
	jq -r '
		def verid: (.version | split(".") | map(tonumber)) | .[0]*10000 + .[1]*100 + (.[2] // 0);
		def distroid: if .distro=="alpine3.24" then 0 elif .distro=="alpine3.23" then 1 elif .distro=="trixie" then 2 else 3 end;
		def rowfields:
			[
				.tag,
				.version,
				.distro,
				(.built_at // "待构建"),
				(if .size then (((.size / 1024 / 1024) * 10 | round) / 10 | tostring) + " MB" else "待扫描" end),
				(if (.critical == null and .high == null) then "待扫描" else ((.critical // 0 | tostring) + "/" + (.high // 0 | tostring)) end)
			] | @tsv;

		( [.[].version] | max ) as $lv
		| [ .[] | select(.version == $lv and .variant == "cli" and (.distro | startswith("alpine") | not)) ][0] as $latest
		| (
			["cli", "zts", "swoole", "thread", "swow"][] as $g
			| select( [.[].variant] | index($g) )
			| [
				"### " + $g,
				"tag\tPHP\t发行版\t构建时间\t镜像大小\t安全扫描 CRITICAL/HIGH",
				"---\t---\t---\t---\t---\t---",
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

awk -v s="$start" -v e="$end" -v b="$formatted" '
	$0 == s { print; print b; in_block = 1; next }
	$0 == e { in_block = 0; print; next }
	in_block { next }
	{ print }
' README.md > README.md.tmp && mv README.md.tmp README.md

echo "updated README tag matrix"
