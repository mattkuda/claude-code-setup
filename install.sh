#!/bin/bash
# Claude Code Setup installer
# Copies agents, commands, skills, and statusline into ~/.claude/
# and seeds settings.json + .mcp.json if they don't already exist.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Installing Claude Code Setup from $SCRIPT_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

mkdir -p "$CLAUDE_DIR"/{agents,commands,skills,statusline}

echo "→ Copying agents..."
cp -R "$SCRIPT_DIR"/agents/. "$CLAUDE_DIR"/agents/

echo "→ Copying commands..."
cp -R "$SCRIPT_DIR"/commands/. "$CLAUDE_DIR"/commands/

echo "→ Copying skills..."
cp -R "$SCRIPT_DIR"/skills/. "$CLAUDE_DIR"/skills/

echo "→ Copying statusline..."
cp "$SCRIPT_DIR"/statusline/statusline.sh "$CLAUDE_DIR"/statusline/
chmod +x "$CLAUDE_DIR"/statusline/statusline.sh

# Seed settings.json only if it doesn't exist (don't clobber personal edits)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  echo "→ Seeding settings.json from template..."
  cp "$SCRIPT_DIR"/settings.example.json "$CLAUDE_DIR"/settings.json
else
  echo "→ settings.json already exists — leaving it alone."
  echo "  See $SCRIPT_DIR/settings.example.json for reference."
fi

# Seed .mcp.json only if it doesn't exist
if [ ! -f "$CLAUDE_DIR/.mcp.json" ]; then
  echo "→ Seeding .mcp.json from template (edit it to add your tokens)..."
  cp "$SCRIPT_DIR"/mcp.example.json "$CLAUDE_DIR"/.mcp.json
else
  echo "→ .mcp.json already exists — leaving it alone."
fi

echo ""
echo "Done. Restart Claude Code so it picks up the new settings."
