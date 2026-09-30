# KobeTools fork of kanata

Upstream: https://github.com/jtroo/kanata. This fork sits on upstream **release tags**
(currently `v1.12.0`) plus the commits below. Re-check after every sync.

| Change | Where |
|---|---|
| Source build with only the `gui` feature: no `tcp_server` (network control port), no `cmd` (config-run shell commands), no `interception_driver` | `scripts/build-install-local.sh` |

The keyboard layout itself lives in wintools (`config/kanata.kbd`), not in this fork.

## Syncing

From wintools run `scripts/audit-upstream.sh kanata` (targets the latest release tag),
review, then `git merge <tag>`. A keyboard hook sees every keystroke: read diffs to
`src/kanata/windows`, `src/oskbd`, `Cargo.toml` features and any new dependency closely.
