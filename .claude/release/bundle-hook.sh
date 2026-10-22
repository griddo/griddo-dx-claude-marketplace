#!/usr/bin/env bash
# Release build hook (marketplace-release SPEC §7). Rebuilds standalone/<plugin>.plugin for every
# plugin the release bumps, so the distributable bundle always matches the published version.
# Required: if a bundle can't be built, the release stops.
set -euo pipefail

ctx="$RELEASE_CONTEXT"
files=()
while IFS=$'\t' read -r name path; do
  [[ -z "$name" ]] && continue
  if [[ "$(jq -r '.dry_run' "$ctx")" == "true" ]]; then
    files+=("standalone/$name.plugin")
    continue
  fi
  out=$(bash .claude/release/bundle-plugin.sh --json --name "$name" --out-dir standalone "$path")
  files+=("$(jq -r '.bundle' <<< "$out")")
done < <(jq -r '.plugins[] | "\(.name)\t\(.path)"' "$ctx")

jq -n '{files: $ARGS.positional}' --args ${files[@]+"${files[@]}"}
