# Griddo Marketplace

Official plugin marketplace for [Griddo](https://griddo.io) — the DXP built for higher-education websites.

> Marketplace v1.0.2

This marketplace packages tools for developers building on Griddo — both Griddo staff and partner teams. The plugin is open source; issues and contributions are welcome.

## Installation

### Individual developers

In Claude Code, add the marketplace and install the plugin:

```
/plugin marketplace add griddo/griddo-dx-claude-marketplace
/plugin install griddo-dx@griddo-dx-claude-marketplace
```

You can also run `/plugin` to browse and install interactively.

### Partner team admins

If you manage a Claude Code team for a Griddo partner organization, you can enable this plugin for your whole team through your team's plugin configuration. The marketplace slug is `griddo/griddo-dx-claude-marketplace`. See the Claude Code docs for team-level plugin management.

### Updating

Pull the latest marketplace metadata and reinstall to pick up new plugin versions:

```
/plugin marketplace update griddo-dx-claude-marketplace
```

## Available plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| **griddo-dx** | Scaffolding de módulos, templates y content types, referencia de fields, hooks, API y schemas | 0.1.0 |

## Contributing

Questions, bug reports, and ideas are welcome via [GitHub Issues](https://github.com/griddo/griddo-dx-claude-marketplace/issues). Pull requests are welcome too — for larger changes, please open an issue first so we can discuss scope.

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold it.

## License

MIT
