#!/usr/bin/env bash
set -euo pipefail

# bundle-plugin.sh — Package a plugin directory into a distributable .plugin archive.
#
# A .plugin file is a zip whose root holds the plugin directory's contents
# (.claude-plugin/plugin.json, skills/, agents/, README.md, ...), which is the
# layout clients expect when installing a plugin from a file rather than from
# the marketplace.
#
# Only git-tracked files are packaged: the bundle then always matches what is
# committed, and local junk (.DS_Store, editor scratch, ignored build output)
# can never reach a partner.

OUT_DIR="standalone"
BUNDLE_NAME=""
PLUGIN_PATH=""
JSON_OUTPUT=false

log() {
  echo "$@" >&2
}

fail() {
  if [[ "$JSON_OUTPUT" == "true" ]]; then
    jq -n --arg error "$1" '{"status": "error", "error": $error}'
  else
    log "Error: $1"
  fi
  exit 1
}

show_help() {
  cat <<'HELP'
Usage: bundle-plugin.sh [OPTIONS] PLUGIN_PATH

Package a plugin directory into a distributable .plugin archive (a zip whose
root is the plugin's own contents). Only git-tracked files are included, so the
bundle mirrors the committed state of the plugin.

Arguments:
  PLUGIN_PATH        Plugin directory, e.g. plugins/griddo-dx

Options:
  --help             Show this help message
  --name NAME        Bundle basename without extension (default: basename of PLUGIN_PATH)
  --out-dir DIR      Output directory, relative to the repo root (default: standalone)
  --json             Emit a JSON result on stdout instead of a human-readable line

Exit codes:
  0  Bundle written
  1  Error (missing plugin, no tracked files, zip failure)
HELP
  exit 0
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help) show_help ;;
      --json) JSON_OUTPUT=true; shift ;;
      --name)
        [[ $# -ge 2 ]] || fail "--name requires a value."
        BUNDLE_NAME="$2"; shift 2 ;;
      --out-dir)
        [[ $# -ge 2 ]] || fail "--out-dir requires a value."
        OUT_DIR="$2"; shift 2 ;;
      -*) fail "Invalid option: $1. Use --help for usage." ;;
      *)
        [[ -z "$PLUGIN_PATH" ]] || fail "Unexpected extra argument: $1"
        PLUGIN_PATH="$1"; shift ;;
    esac
  done

  [[ -n "$PLUGIN_PATH" ]] || fail "PLUGIN_PATH is required. Use --help for usage."
  PLUGIN_PATH="${PLUGIN_PATH%/}"
}

main() {
  parse_args "$@"

  command -v zip >/dev/null 2>&1 || fail "zip is not installed; cannot build the distributable bundle."

  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || fail "Not inside a git repository."
  cd "$repo_root"

  [[ -d "$PLUGIN_PATH" ]] || fail "Plugin directory not found: $PLUGIN_PATH"
  [[ -f "$PLUGIN_PATH/.claude-plugin/plugin.json" ]] || \
    fail "Not a plugin directory (missing .claude-plugin/plugin.json): $PLUGIN_PATH"

  [[ -n "$BUNDLE_NAME" ]] || BUNDLE_NAME=$(basename "$PLUGIN_PATH")

  local bundle="$OUT_DIR/$BUNDLE_NAME.plugin"
  local bundle_abs="$repo_root/$bundle"

  local file_count
  file_count=$(git -C "$PLUGIN_PATH" ls-files | grep -c . || true)
  [[ "$file_count" -gt 0 ]] || fail "No git-tracked files under $PLUGIN_PATH; nothing to bundle."

  mkdir -p "$OUT_DIR"
  # zip updates an existing archive in place, which would keep files that have
  # since been deleted from the plugin. Always start from scratch.
  rm -f "$bundle_abs"

  # -X drops platform extra fields; git ls-files is sorted, so the entry order
  # is stable across machines.
  ( cd "$PLUGIN_PATH" && git ls-files -z | xargs -0 zip -q -X "$bundle_abs" ) \
    || fail "zip failed while building $bundle"

  local version size_bytes
  version=$(jq -r '.version // "unknown"' "$PLUGIN_PATH/.claude-plugin/plugin.json")
  size_bytes=$(wc -c < "$bundle_abs" | tr -d ' ')

  if [[ "$JSON_OUTPUT" == "true" ]]; then
    jq -n \
      --arg status "ok" \
      --arg name "$BUNDLE_NAME" \
      --arg plugin_path "$PLUGIN_PATH" \
      --arg bundle "$bundle" \
      --arg version "$version" \
      --argjson file_count "$file_count" \
      --argjson size_bytes "$size_bytes" \
      '{
        status: $status,
        name: $name,
        plugin_path: $plugin_path,
        bundle: $bundle,
        version: $version,
        file_count: $file_count,
        size_bytes: $size_bytes
      }'
  else
    log "Bundled $BUNDLE_NAME v$version → $bundle ($file_count files, $size_bytes bytes)"
  fi
}

main "$@"
