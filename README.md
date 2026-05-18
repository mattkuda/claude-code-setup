# claude-code-setup

My personal Claude Code configuration — status line, agents, commands, skills, hooks, and settings. Clone it on any machine and run one script to get the same setup.

```
[Opus 4.7 (1M context)] 🟢 5% (52K/1000K) | 📁 Development | ⏱ 43m
```

## Quick install

```bash
git clone https://github.com/mattkuda/claude-code-setup.git
cd claude-code-setup
./install.sh
```

Then restart Claude Code so it reloads `~/.claude/settings.json`.

The installer copies files into `~/.claude/`. It will **not** overwrite an existing `settings.json` or `.mcp.json` — those get seeded only on a fresh install.

## What's inside

| Path | What it is |
|---|---|
| `settings.example.json` | Template for `~/.claude/settings.json` — hooks, statusline, env vars, plugins |
| `mcp.example.json` | Template for `~/.claude/.mcp.json` — MCP servers (Supabase etc.) |
| `statusline/statusline.sh` | Bash script that renders the status line |
| `agents/` | Custom subagents (UI design research, Dribbble research) |
| `commands/` | Slash commands (`/review-branch`, `/scaffold-app`, `/tweet`) |
| `skills/` | Skills (`html-spec`, `landing-page-copy`) |
| `install.sh` | Copies everything into `~/.claude/` |

## Status line

`statusline/statusline.sh` reads JSON on stdin from Claude Code and prints:

`[Model] <colored dot> <context %> (<tokens used>/<context size>) | 📁 cwd | 🌿 branch | ⏱ session duration`

- 🟢 < 60% context, 🟡 60–80%, 🔴 ≥ 80%
- Session duration persists per-session via a tiny tmpfile in `~/.claude/statusline/`
- Git branch only shows when the cwd is inside a repo

Wired up in settings via:

```json
"statusLine": {
  "type": "command",
  "command": "$HOME/.claude/statusline/statusline.sh"
}
```

## Notable settings

- **Stop / Notification hooks** play `Glass.aiff` when Claude finishes a turn or needs permission — handy when working in another window.
- **`CLAUDE_CODE_EFFORT=max`** maxes out reasoning effort.
- **`defaultMode: bypassPermissions`** + **`dangerously-skip-permissions: true`** skip most permission prompts. **Read these before installing** — they trade safety for speed. Remove them if you'd rather be prompted before destructive tool calls.
- **Plugins**: `frontend-design`, `swift-lsp`, `feature-dev` (official) and `andrej-karpathy-skills` (from `forrestchang/andrej-karpathy-skills`).

## Updating

After pulling new commits, re-run `./install.sh` to push the latest agents/commands/skills/statusline into `~/.claude/`. Your local `settings.json` and `.mcp.json` are left untouched — diff them against the `.example` files manually if you want to pull in new defaults.

## License

MIT.
