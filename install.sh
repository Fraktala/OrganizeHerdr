#!/usr/bin/env bash
# Installs the agents-progress mod, a layout that uses it, and the herdr-team skill.
# Safe to run again. Herdr must be running, because the layout is cloned through the app.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
herdr_home="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
claude_home="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
layout="$herdr_home/layouts/main-progress.json"

if ! command -v herdr-app >/dev/null; then
  echo "herdr-app not found on PATH. Install Herdr first: https://herdr.dev" >&2
  exit 1
fi

mkdir -p "$herdr_home/mods/agents-progress" "$claude_home/skills/herdr-team"
cp "$root/mods/agents-progress/main.js" "$root/mods/agents-progress/mod.json" "$herdr_home/mods/agents-progress/"
cp "$root/skills/herdr-team/SKILL.md" "$claude_home/skills/herdr-team/"

herdr-app check "$herdr_home/mods/agents-progress"

if [ ! -f "$layout" ]; then
  herdr-app do layout.clone '{"name":"main","as":"main-progress"}' >/dev/null
fi
sed 's/"mod": "agents"$/"mod": "agents-progress"/' "$layout" >"$layout.tmp"
mv "$layout.tmp" "$layout"
herdr-app do layout.switch '{"name":"main-progress"}' >/dev/null

echo "Installed. Herdr now uses the main-progress layout."
