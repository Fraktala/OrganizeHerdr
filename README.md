# OrganizeHerdr

A mod for the [Herdr](https://herdr.dev) desktop app and a Claude Code skill for running teams of agents. The Agents list gains progress bars, a lead-and-worker tree, and quick access to extra terminal sets.

## Features

- **Progress bars** for each agent: one for the whole task, or main and subtask together.
- **Status colours:** red when an agent is blocked or has failed, blue when it is waiting for an answer.
- **Lead and worker tree** with collapsible leads, any depth of sub-agents, and a role name such as "Python implementation".
- **Tab badges** showing where each lead and worker lives.
- **Terminal sets:** the `+` beside a project opens a clean terminal in a new space, listed under that project below a divider. Hover over a divider for another `+`.
- **`herdr-team` skill** for starting workers, messaging between them and their lead, and handling blocked or failed workers.
- **`herdr-workspace` skill (optional)** teaching an agent to report progress, open tabs and spaces, and give workers their own tabs.

## Requirements

- Herdr desktop app with `herdr-app` and `hc` on `PATH`. Herdr must be running during installation.
- [Claude Code](https://claude.com/claude-code) for the skill and for agents that report status.

## Install

```sh
git clone https://github.com/Fraktala/OrganizeHerdr.git
cd OrganizeHerdr
./install.sh
```

The script copies the mod to `~/.config/herdr-app/mods/agents-progress`, creates and activates the `main-progress` layout, and copies the skill to `~/.claude/skills/herdr-team`. Herdr's own `main` layout and `agents` mod are not changed.

The `herdr-workspace` skill is not installed by default. To add it, at install time or later:

```sh
./install.sh --workspace-skill
```

To remove everything, run `./uninstall.sh`.

## Reporting progress

An agent or its lead sets labels on the terminal, and the list computes percentages from the counts.

```sh
hc label "$HC_TERMINAL_ID" task.done=3 task.total=7 "task.text=Payment module"
hc label "$HC_TERMINAL_ID" task.sub.done=12 task.sub.total=20 "task.sub.text=Migrating files"
hc label worker-1 "agent.role=Python implementation"
hc label "$HC_TERMINAL_ID" task.done= task.total= task.text= task.sub.done= task.sub.total= task.sub.text=
```

| Label | Meaning |
|---|---|
| `task.done`, `task.total`, `task.text` | Whole task |
| `task.sub.done`, `task.sub.total`, `task.sub.text` | Current subtask, shown as a second bar |
| `agent.role` | Name shown in the list instead of the session title |
| `lead` | Attaches a terminal started elsewhere under a lead, e.g. `lead=t8` |

Setting a label to an empty value removes it.

## Limitations

- Claude Code has to report progress itself, so a bar can lag or stay empty if the agent does not update it.
- Terminal sets are recognised by their space name, a project name followed by a number, such as `MyProject 2`. Renaming such a space removes it from the Agents list, but it stays under Spaces.
- The mod is a modified copy of Herdr's `agents` mod from version 0.1.14. It is not updated with Herdr and may need changes after large Herdr releases.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
