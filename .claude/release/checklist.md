# Release checklist — griddo-dx-claude-marketplace

Step 0 of `/marketplace-release:release`. Apply every item before running the release script.
Fix anything stale in its own commit first (`docs: refresh README to current skills`); the script
requires a clean tree. Leave version numbers alone; the release handles them.

This repo is **public**. Maintainers enable the `marketplace-release` plugin in their own user
settings, not in a committed `.claude/settings.json`, which would point every visitor to a
marketplace they can't reach.

## griddo-dx

- Enumerate what ships (`ls plugins/griddo-dx/skills/ plugins/griddo-dx/agents/`). The plugin's
  README and its row in `README.md` still describe it, and nothing removed or renamed is listed.
- Nothing internal to Griddo (client names, internal URLs, credentials, private repos) appears in
  what ships: partners install this plugin.

## standalone/

The release rebuilds `standalone/<plugin>.plugin` for every plugin it bumps (build hook
`bundle-hook.sh`). If the bundle can't be built, the release stops.
