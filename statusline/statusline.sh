#!/bin/bash
# Claude Code Status Line
# Shows: [Model] Context% (tokens) | 📁 Directory | 🌿 Git Branch | ⏱️ Last Message Time
#
# Install: Add to ~/.claude/settings.json:
# {
#   "statusLine": {
#     "type": "command",
#     "command": "$HOME/.claude/statusline/statusline.sh"
#   }
# }

input=$(cat)

# Parse JSON input
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
# Shorten "(1M context)" → "1M" so the model label stays compact
MODEL=$(echo "$MODEL" | sed -E 's/ ?\(1M context\)/ 1M/')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
USAGE=$(echo "$input" | jq '.context_window.current_usage // empty')

# Resolve current effort level. Claude Code passes effort as either a string
# ("xhigh") or an object ({"level": "xhigh"}), so try `.level` first, then the
# bare value. Priority: input JSON → settings.json → CLAUDE_CODE_EFFORT env var.
EFFORT=$(echo "$input" | jq -r '
    def normalize(x): x | if type == "object" then .level // empty
                          elif type == "string" then .
                          else empty end;
    (normalize(.effort) // normalize(.model.effort) //
     .effortLevel // empty)')
if [ -z "$EFFORT" ] || [ "$EFFORT" = "null" ]; then
    if [ -f "$HOME/.claude/settings.json" ]; then
        EFFORT=$(jq -r '.effortLevel // .effort // empty' "$HOME/.claude/settings.json" 2>/dev/null)
    fi
fi
if [ -z "$EFFORT" ] || [ "$EFFORT" = "null" ]; then
    EFFORT="${CLAUDE_CODE_EFFORT:-}"
fi
[ "$EFFORT" = "null" ] && EFFORT=""

# Calculate context usage
if [ -n "$USAGE" ] && [ "$USAGE" != "null" ]; then
    CONTEXT_INPUT=$(echo "$USAGE" | jq -r '.input_tokens // 0')
    CACHE_CREATE=$(echo "$USAGE" | jq -r '.cache_creation_input_tokens // 0')
    CACHE_READ=$(echo "$USAGE" | jq -r '.cache_read_input_tokens // 0')

    CURRENT_TOKENS=$((CONTEXT_INPUT + CACHE_CREATE + CACHE_READ))
    PERCENT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))

    # Format token count (e.g., 84K/200K)
    CURRENT_K=$((CURRENT_TOKENS / 1000))
    MAX_K=$((CONTEXT_SIZE / 1000))
    TOKEN_DISPLAY="${CURRENT_K}K/${MAX_K}K"
else
    PERCENT=0
    TOKEN_DISPLAY="0K"
fi

# Color-coded context indicator
if [ "$PERCENT" -ge 80 ]; then
    CONTEXT_ICON="🔴"
elif [ "$PERCENT" -ge 60 ]; then
    CONTEXT_ICON="🟡"
else
    CONTEXT_ICON="🟢"
fi

# Get current working directory
CWD=$(echo "$input" | jq -r '.cwd // "."')
DIR_NAME=$(basename "$CWD")
DIR_DISPLAY="📁 $DIR_NAME"

# Get git branch (if in a git repo)
GIT_BRANCH=$(cd "$CWD" 2>/dev/null && git branch --show-current 2>/dev/null || echo "")
if [ -n "$GIT_BRANCH" ]; then
    GIT_DISPLAY="🌿 $GIT_BRANCH"
else
    GIT_DISPLAY=""
fi

# Time since the user's last sent message.
# The transcript records every entry with an ISO timestamp. A message the user
# typed is type=="user" whose content[0].type=="text"; tool results are also
# type=="user" but start with "tool_result", so we exclude those.
CURRENT_TIME=$(date +%s)
START_TIME=""

TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // empty')
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    LAST_MSG_TS=$(jq -rc 'select(.type=="user"
        and (.message.content | type=="array")
        and (.message.content[0].type=="text"))
        | .timestamp' "$TRANSCRIPT" 2>/dev/null | tail -1)
    if [ -n "$LAST_MSG_TS" ] && [ "$LAST_MSG_TS" != "null" ]; then
        # ISO8601 UTC, e.g. 2026-06-07T12:43:03.326Z → strip fraction + Z, parse as UTC.
        CLEAN_TS=${LAST_MSG_TS%.*}; CLEAN_TS=${CLEAN_TS%Z}
        START_TIME=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$CLEAN_TS" +%s 2>/dev/null)
    fi
fi

# Fallback: per-session start time (if transcript/timestamp unavailable).
if [ -z "$START_TIME" ]; then
    SESSION_ID=$(echo "$input" | jq -r '.session_id // "default"')
    SESSION_FILE="$HOME/.claude/statusline/session-$SESSION_ID.time"
    mkdir -p "$HOME/.claude/statusline"
    if [ -f "$SESSION_FILE" ]; then
        START_TIME=$(cat "$SESSION_FILE")
    else
        START_TIME=$CURRENT_TIME
        echo "$START_TIME" > "$SESSION_FILE"
    fi
fi

# Absolute timestamp of the user's last message — e.g. "Apr 14, 3:45pm".
# Deliberately absolute, not relative ("35m ago"): the status line only
# re-renders on Claude Code's refresh cadence, so a relative value freezes
# when you switch away and come back. An absolute timestamp is correct
# whenever it was last drawn — nothing to keep updating.
MON=$(date -r "$START_TIME" "+%b")
DAY=$(date -r "$START_TIME" "+%d" | sed 's/^0//')
CLOCK=$(date -r "$START_TIME" "+%I:%M%p" | sed 's/^0//' | tr '[:upper:]' '[:lower:]')
TIME_DISPLAY="⏱️ ${MON} ${DAY}, ${CLOCK}"

# Build model segment (with effort level if known)
if [ -n "$EFFORT" ]; then
    MODEL_DISPLAY="[$MODEL · $EFFORT]"
else
    MODEL_DISPLAY="[$MODEL]"
fi

# Build status line
if [ -n "$GIT_DISPLAY" ]; then
    echo "$MODEL_DISPLAY $CONTEXT_ICON ${PERCENT}% ($TOKEN_DISPLAY) | $DIR_DISPLAY | $GIT_DISPLAY | $TIME_DISPLAY"
else
    echo "$MODEL_DISPLAY $CONTEXT_ICON ${PERCENT}% ($TOKEN_DISPLAY) | $DIR_DISPLAY | $TIME_DISPLAY"
fi
