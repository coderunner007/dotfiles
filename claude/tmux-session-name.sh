#!/usr/bin/env bash
[ -z "$TMUX" ] && exit 0

MODE=$1
INPUT=$(cat)

if [ "$MODE" = "start" ]; then
  SESSION_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_title') or d.get('session_id','claude')[:8])" 2>/dev/null)
  [ -n "$SESSION_NAME" ] && tmux rename-window "claude-$SESSION_NAME"

elif [ "$MODE" = "rename" ]; then
  SESSION_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('session_title') or d.get('session_id','claude')[:8])" 2>/dev/null)
  [ -n "$SESSION_NAME" ] && tmux rename-window "claude-$SESSION_NAME"

elif [ "$MODE" = "stop" ]; then
  tmux set-window-option automatic-rename on
fi
