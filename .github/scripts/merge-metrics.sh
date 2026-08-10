#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/../.."

# 1. base structure (tag/version/variant/distro) from versions.json
metrics="$(
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

# 2. merge image size / build time from uploaded artifacts (size-<tag>.json)
while IFS= read -r -d '' f; do
	tag="$(jq -r '.tag' "$f")"
	size="$(jq -r '.size' "$f")"
	built_at="$(jq -r '.built_at // ""' "$f")"
	metrics="$(jq -c --arg t "$tag" --argjson s "$size" --arg b "$built_at" \
		'map(if .tag == $t then .size = $s | .built_at = $b else . end)' <<<"$metrics")"
done < <(find . -path './.git' -prune -o -type f -name 'size-*.json' -print0 2>/dev/null)

# 3. merge scan results from uploaded SARIF files (trivy-<tag>.sarif)
#    Trivy SARIF levels: critical -> "error", high -> "warning"
while IFS= read -r -d '' f; do
	tag="$(basename "$f" | sed 's/^trivy-//; s/\.sarif$//')"
	critical="$(jq '[.runs[].results[]? | select(.level == "error")] | length' "$f" 2>/dev/null || echo 0)"
	high="$(jq '[.runs[].results[]? | select(.level == "warning")] | length' "$f" 2>/dev/null || echo 0)"
	metrics="$(jq -c --arg t "$tag" --argjson c "$critical" --argjson h "$high" \
		'map(if .tag == $t then .critical = $c | .high = $h else . end)' <<<"$metrics")"
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
echo "wrote .image-metrics.json ($(jq 'length' .image-metrics.json) entries) and .build-state.json"
