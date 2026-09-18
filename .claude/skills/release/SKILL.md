---
name: release
description: Bump plugin and marketplace versions, rebuild the distributable .plugin bundles, update README, sync marketplace.json, commit, push, and create PR
---

# Release - Version Bump and PR Creation

Detects changed plugins and marketplace-level changes since the last release, bumps their versions independently, repackages each bumped plugin into `standalone/NAME.plugin`, updates README.md, syncs marketplace.json, commits, pushes, and creates a PR.

Supports both flat (`PLUGIN_NAME/`) and nested (`plugins/PLUGIN_NAME/`) plugin layouts. The plugin's directory is read from `source` in `marketplace.json`; the `name` field is used only for identifying the plugin in marketplace.json and in commit messages.

## Available scripts

- **`scripts/release.sh`** — Validates branch, detects changes, bumps versions in JSON files, rebuilds the distributable bundles, outputs structured JSON. Run with `--help` for details.
- **`scripts/scan-secrets.sh`** — Scans tracked files for likely exposed credentials. Invoked by `release.sh` as a pre-release gate; can also be run standalone. Run with `--help` for details.
- **`scripts/bundle-plugin.sh`** — Packages a plugin directory into `standalone/NAME.plugin`, the single-file archive partners install without going through the marketplace. Invoked by `release.sh` for every bumped plugin; can also be run on its own to rebuild a bundle. Run with `--help` for details.

## Distributable bundles

`standalone/NAME.plugin` is a zip whose root is the plugin's own contents (`.claude-plugin/plugin.json`, `skills/`, `agents/`, `README.md`). It is committed, not ignored, because partners install from it directly.

Only git-tracked files are packaged, so a bundle always mirrors the committed plugin and never carries local junk. `release.sh` rebuilds it after the version bump, so the `plugin.json` inside the archive always reports the version being released.

## Usage

```
/release          # Auto-detect bump type from commit messages
/release patch    # Force patch bump
/release minor    # Force minor bump
/release major    # Force major bump
```

## Instructions

Execute the following steps IN ORDER. Do NOT skip steps. Do NOT ask the user questions — this is a fully automated process.

### Step 1: Run release script

Run:
```bash
bash .claude/skills/release/scripts/release.sh $ARGUMENTS
```

Parse the JSON output. Handle by `status` field:
- `"error"`: Print the `error` message and STOP. If the payload includes a `findings` array (credential scan), list each finding (`file:line [pattern] match_preview`) and tell the user to redact the values with `[REDACTED]` before re-running, or to pass `--skip-secret-scan` if the matches are confirmed false positives.
- `"no_changes"`: Print the `message` and STOP.
- `"ok"`: Save all fields and continue.

The JSON contains: `branch`, `bump_type`, `plugins` (array with `name`/`path`/`old_version`/`new_version`/`file`/`bundle`), `marketplace` (changed/old_version/new_version), `files_modified`, `commit_message`, `commits_since_baseline`.

`files_modified` already includes each rebuilt `standalone/NAME.plugin`, so staging that array is enough to ship the bundles with the release.

### Step 2: Update README.md

Use the Read tool to read `README.md`.

#### 2a. Update plugin versions in table

For each plugin in the `plugins` array:
- If a row for `[PLUGIN_NAME]` exists in the Available Plugins table, use the Edit tool to replace `old_version` with `new_version` in that row.
- If no row exists (new plugin), read its description from marketplace.json and use the Edit tool to add a new row. Use the plugin's `path` (from the JSON output) for links, NOT its `name`:
  ```
  | **PLUGIN_NAME** | DESCRIPTION | NEW_VERSION |
  ```
  If the README table includes a README column, append `| [README](PATH/README.md) |` using the `path` field.

#### 2b. Update marketplace version

If `marketplace.changed` is `true`, use the Edit tool to replace:
```
> Marketplace vOLD_VERSION
```
with:
```
> Marketplace vNEW_VERSION
```

### Step 3: Commit

Stage all modified files:
```bash
git add README.md
```

Also stage each file from the `files_modified` array:
```bash
git add FILE1 FILE2 ...
```

Create commit using the `commit_message` from the JSON output:
```bash
git commit -m "COMMIT_MESSAGE"
```

### Step 4: Push

```bash
git push origin BRANCH
```

If it fails:
```bash
git push --set-upstream origin BRANCH
```

### Step 5: Create or Detect PR

Check for existing open PR:
```bash
gh pr view --json url,state 2>/dev/null
```

**If a PR exists and state is `OPEN`**: Print the URL. Done.

**If no PR exists**: Create one.

PR title rules (using JSON data):
- Only plugins (one): `feat(PLUGIN_NAME): release vNEW_VERSION`
- Only plugins (multiple): `feat(release): bump versions`
- Only marketplace: `chore(marketplace): release vNEW_VERSION`
- Both changed: `feat(release): bump versions`

PR body template:
```
## Release Summary

### Version Changes
- **marketplace**: OLD_VERSION → NEW_VERSION (BUMP_TYPE)
- **PLUGIN_NAME**: OLD_VERSION → NEW_VERSION (BUMP_TYPE)

### Commits
COMMITS_SINCE_BASELINE (one per line)

---
*Auto-generated by `/release` skill*
```

Only include rows for components that were actually bumped.

### Step 6: Report

Print summary:
```
Release complete!

  Component    Version            Bump
  marketplace  OLD → NEW          TYPE
  PLUGIN       OLD → NEW          TYPE

  Bundles: standalone/NAME.plugin (one per bumped plugin)
  Commit: HASH
  Branch: BRANCH
  PR: URL
```

Only include rows for components that were actually bumped. Omit the `Bundles` line when no plugin was bumped.

## Error Handling

- If `scripts/release.sh` exits non-zero, its stdout contains error/no-changes JSON. Print the message and stop.
- A bundling failure (missing `zip`, unreadable plugin directory) aborts the release before the commit, so partners never get a release whose `.plugin` archive lags the published version.
- If `git push` fails, print the error and suggest resolving manually.
- If `gh pr create` fails, print the error. The version bump commit is still valid.
