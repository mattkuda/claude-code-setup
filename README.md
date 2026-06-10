# claude-code-setup

My personal Claude Code configuration — status line, agents, commands, skills, hooks, and settings. Clone it on any machine and run one script to get the same setup.

```
[Opus 4.8 1M · xhigh] 🟢 14% (142K/1000K) | 📁 evex-backend | 🌿 master | ⏱️ Jun 8, 9:14am
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
| `skills/` | Skills (`grill-me`, `html-spec`, `landing-page-copy`) |
| `install.sh` | Copies everything into `~/.claude/` |

## Status line

`statusline/statusline.sh` reads JSON on stdin from Claude Code and prints:

`[Model · effort] <colored dot> <context %> (<tokens used>/<context size>) | 📁 cwd | 🌿 branch | ⏱️ last message time`

- 🟢 < 60% context, 🟡 60–80%, 🔴 ≥ 80%
- The right segment shows the **absolute time of your last sent message**, read from the session transcript (`transcript_path`) — the last entry you typed, ignoring tool results — formatted like `Jun 8, 9:14am`. It's deliberately absolute, not relative (`13m ago`): the status line only re-renders on Claude Code's refresh cadence, so a relative value freezes when you switch away and come back, whereas an absolute timestamp stays correct with nothing to update. Falls back to a per-session tmpfile in `~/.claude/statusline/` if the transcript isn't readable.
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
- **Plugins**: `frontend-design`, `swift-lsp`, `feature-dev`, `superpowers` (official); `andrej-karpathy-skills` (from `forrestchang/andrej-karpathy-skills`); `warp` (from `warpdotdev/claude-code-warp`).

## Updating

After pulling new commits, re-run `./install.sh` to push the latest agents/commands/skills/statusline into `~/.claude/`. Your local `settings.json` and `.mcp.json` are left untouched — diff them against the `.example` files manually if you want to pull in new defaults.

## License

MIT.
