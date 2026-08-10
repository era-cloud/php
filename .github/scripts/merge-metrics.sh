#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/../.."

# 0. nothing built this run (no size artifacts) -> skip all updates so we don't
#    clobber previously recorded metrics on no-op / change-skip runs
if ! find . -path './.git' -prune -o -type f -name 'size-*.json' -print -quit 2>/dev/null | grep -q .; then
	echo "no size artifacts found; nothing built this run, skipping metrics update"
	exit 0
fi

# 1. base structure (tag/version/variant/distro) from versions.json
base="$(
	jq -c '
		[
			to_entries | map(select(.value)) | .[]
			| . as $e
			| $e.key as $v
			| $e.value.variants[]
			| split("/") as $p
			| { tag: ("\($v)-\($p[1])-\($p[0])"), version: $v, variant: $p[1], distro: $p[0], built_at: null, size: null, critical: null, high: null }
		]
	' versions.json
)"

# 1b. start from previously recorded metrics where present, so variants not
#     rebuilt in this run keep their last known size/build time/scan results
if [ -f .image-metrics.json ]; then
	metrics="$(jq -c --argjson existing "$(cat .image-metrics.json)" \
		'[ .[] | . as $b | (first($existing[] | select(.tag == $b.tag)) // $b) ]' \
		<<<"$base")"
else
	metrics="$base"
fi

# 2. merge image size / build time from uploaded artifacts (size-<tag>.json)
#    artifact tags are full (8.2.33-cli-trixie); normalize to short (8.2-cli-trixie) to match base
while IFS= read -r -d '' f; do
	tag="$(jq -r '.tag' "$f" | sed -E 's/^([0-9]+\.[0-9]+)\.[0-9]+(-.*)$/\1\2/')"
	size="$(jq -r '.size' "$f")"
	built_at="$(jq -r '.built_at // ""' "$f")"
	metrics="$(jq -c --arg t "$tag" --argjson s "$size" --arg b "$built_at" \
		'map(if .tag == $t then .size = $s | .built_at = $b else . end)' <<<"$metrics")"
done < <(find . -path './.git' -prune -o -type f -name 'size-*.json' -print0 2>/dev/null)

# 3. merge scan results from uploaded SARIF files (trivy-<tag>.sarif)
#    Trivy SARIF levels: critical -> "error", high -> "warning"
while IFS= read -r -d '' f; do
	tag="$(basename "$f" | sed 's/^trivy-//; s/\.sarif$//' | sed -E 's/^([0-9]+\.[0-9]+)\.[0-9]+(-.*)$/\1\2/')"
	critical="$(jq '[.runs[].results[]? | select(.level == "error")] | length' "$f" 2>/dev/null || echo 0)"
	high="$(jq '[.runs[].results[]? | select(.level == "warning")] | length' "$f" 2>/dev/null || echo 0)"
	metrics="$(jq -c --arg t "$tag" --argjson c "$critical" --argjson h "$high" \
		'map(if .tag == $t then .critical = $c | .high = $h else . end)' <<<"$metrics")"
done < <(find . -path './.git' -prune -o -type f -name 'trivy-*.sarif' -print0 2>/dev/null)

# 3b. record detailed CRITICAL/HIGH findings (CVE id / package / version) per
#     variant into .scan-results.json; start from previous details so variants
#     not scanned this run keep their last recorded findings
if [ -f .scan-results.json ]; then
	details="$(jq -c '.' .scan-results.json)"
else
	details='{}'
fi
while IFS= read -r -d '' f; do
	tag="$(basename "$f" | sed 's/^trivy-//; s/\.sarif$//' | sed -E 's/^([0-9]+\.[0-9]+)\.[0-9]+(-.*)$/\1\2/')"
	findings="$(jq -c '[.runs[].results[]? | select(.level == "error" or .level == "warning") | {
		id: (.ruleId // "unknown"),
		package: (.message.text | capture("Package: (?<p>[^\\n]*)") | .p // ""),
		version: (.message.text | capture("Installed Version: (?<v>[^\\n]*)") | .v // ""),
		severity: (if .level == "error" then "CRITICAL" else "HIGH" end)
	}]' "$f" 2>/dev/null || echo '[]')"
	crit="$(jq -c '[.[] | select(.severity == "CRITICAL") | del(.severity)]' <<<"$findings")"
	high="$(jq -c '[.[] | select(.severity == "HIGH") | del(.severity)]' <<<"$findings")"
	details="$(jq -c --arg t "$tag" --argjson c "$crit" --argjson h "$high" \
		'.[$t] = { critical: $c, high: $h }' <<<"$details")"
done < <(find . -path './.git' -prune -o -type f -name 'trivy-*.sarif' -print0 2>/dev/null)

# 4. update .build-state.json: record HEAD for every built variant (has a size artifact)
if [ ! -f .build-state.json ]; then
	echo '{}' > .build-state.json
fi
head_sha="$(git rev-parse HEAD)"
while IFS= read -r -d '' f; do
	tag="$(basename "$f" | sed 's/^size-//; s/\.json$//')"
	jq --arg t "$tag" --arg h "$head_sha" '.[$t] = $h' .build-state.json > .build-state.json.tmp && mv .build-state.json.tmp .build-state.json
done < <(find . -path './.git' -prune -o -type f -name 'size-*.json' -print0 2>/dev/null)

jq . <<<"$metrics" > .image-metrics.json
jq -S . <<<"$details" > .scan-results.json
echo "wrote .image-metrics.json ($(jq 'length' .image-metrics.json) entries), .scan-results.json ($(jq 'length' .scan-results.json) variants) and .build-state.json"
