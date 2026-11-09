---
name: herdr-workspace
description: Use when running inside Herdr (HC_TERMINAL_ID is set) and showing task progress in the Agents list, opening separate Herdr tabs or spaces, or starting workers that need their own visible tab or pane.
---

# Herdr workspace

## Overview

Herdr draws what terminals report. Progress and role names are `hc` labels, read by the `agents-progress` mod. Tabs and panes are created with `herdr-app do`.

For messaging between workers and handling failures, use the `herdr-team` skill.

## Progress bars

The list computes percentages from the counts.

```sh
hc label "$HC_TERMINAL_ID" task.done=2 task.total=5 "task.text=Short step name"
hc label "$HC_TERMINAL_ID" task.sub.done=12 task.sub.total=20 "task.sub.text=Countable items"
hc label "$HC_TERMINAL_ID" task.done= task.total= task.text= task.sub.done= task.sub.total= task.sub.text=
```

- Use them for work of three or more steps. Update after each finished step, and clear them when done.
- Add `task.sub.*` only for real countable items. Never invent a percentage.
- Do not set colours or send OSC 7501. Colour follows the agent's status, and Claude Code overwrites any status you send.

## Tabs and spaces

```sh
herdr-app do tab.new '{"name":"python","folder":"'"$PWD"'"}'
herdr-app do tab.new '{"name":"review","folder":"'"$PWD"'","argv":["claude"],"task":"First message"}'
herdr-app do space.new '{"name":"MyProject 2","folder":"'"$PWD"'"}'
```

Always pass `folder`, because the default can be a stale one. A terminal's real folder is `.foreground.cwd` in `hc get <t> --json`; its `.cwd` is only where it launched.

A session from `tab.new` or `space.new` has no parent, so it is independent of you. A space named `<existing space> <number>` is listed under that project below a divider.

## Workers with their own tab

A worker from `hc run` is yours: it nests under you in the list and you get notes when it blocks. It has no pane until you give it one.

```sh
a=$(hc run --bg --outlive-parent --name worker-1 --cwd "$PWD" claude "$BRIEF" | jq -r .address)
hc label "$a" "agent.role=Python implementation"

# keep fails until the session has booted
end=$((SECONDS+40))
until [ $SECONDS -ge $end ] || [ -n "$(hc get "$a" --json | jq -r '.status.state // empty')" ]; do :; done

herdr-app do terminal.keep '{"terminal":"'"$a"'","place":"tab"}'   # prints the new tab's id
```

For the next workers in that tab, select it first, because `right` and `down` split the focused pane:

```sh
herdr-app do tab.select '{"id":"<tab id>"}'
herdr-app do terminal.keep '{"terminal":"<address>","place":"right"}'
```

Name the tab with `tab.rename {id, name}`. If it answers `no tab`, the tab is still settling, so retry. Confirm the result with `herdr-app ls`.

`agent.role` is the name shown in the list, so describe the kind of work. `--name` is only the address.

## Common mistakes

| Mistake | Result | Fix |
|---|---|---|
| `terminal.keep` before boot | `no running terminal` | Wait for a status |
| `right`/`down` without selecting the tab | Worker lands in the wrong tab | `terminal.park`, select the tab, `terminal.keep` again |
| `hc send` with `/rename` | Agent reads it as text | Slash commands cannot be sent; use `agent.role` |
| `claude -n name` | Session title is fixed to that name | Leave it out |
| Bars left after finishing | Stale progress in the list | Clear all `task.*` labels |
