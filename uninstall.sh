#!/usr/bin/env bash
# Returns Herdr to its main layout and removes only what install.sh added.
set -euo pipefail

herdr_home="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
claude_home="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

if command -v herdr-app >/dev/null; then
  herdr-app do layout.switch '{"name":"main"}' >/dev/null || true
fi

rm -f "$herdr_home/layouts/main-progress.json"
rm -rf "$herdr_home/mods/agents-progress" "$claude_home/skills/herdr-team" "$claude_home/skills/herdr-workspace"

echo "Removed. Herdr is back on its main layout."
