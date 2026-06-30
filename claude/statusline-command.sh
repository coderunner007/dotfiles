#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors the p10k lean prompt style: dir + git branch on left, model + time on right

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

# Shorten home directory to ~
home="$HOME"
short_dir="${cwd/#$home/~}"

# Get git branch (skip optional locks to avoid contention)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>/dev/null; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Determine mode indicator
# Agent mode: agent field is present in JSON
# Plan mode: detected from transcript — the harness appends a plan_mode_exit attachment
#            to turns when plan mode is active. We check the last few lines of the
#            transcript for this attachment type.
# Normal mode: fallback
mode_label=""
mode_color=""
if [ -n "$agent_name" ]; then
  mode_label="agent"
  mode_color="\033[35m"  # magenta
fi
if [ -z "$mode_label" ] && [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # Check the last 10 lines of the transcript for a plan_mode_exit attachment,
  # which the harness prepends to indicate plan mode is currently active.
  if tail -n 10 "$transcript_path" 2>/dev/null | grep -q '"type":"plan_mode_exit"'; then
    mode_label="plan"
    mode_color="\033[33m"  # yellow
  fi
fi
# Normal mode: no indicator shown (it is the default state)

# Build left side: dir (cyan) + git branch (green)
left=$(printf "\033[36m%s\033[0m" "$short_dir")
if [ -n "$git_branch" ]; then
  left="$left $(printf "\033[32m%s\033[0m" "$git_branch")"
fi
if [ -n "$mode_label" ]; then
  mode_indicator=$(printf "%s[%s]\033[0m" "$mode_color" "$mode_label")
  left="$left $mode_indicator"
fi

# Build right side: model (dim) + token metrics + rate limits + time (dim)
right=$(printf "\033[2m%s\033[0m" "$model")

# Token consumption: show raw token count (e.g. "42k tok") + context % used
if [ -n "$total_tokens" ]; then
  if [ "$total_tokens" -ge 1000 ] 2>/dev/null; then
    tok_display=$(printf "%.0fk" "$(echo "$total_tokens" | awk '{print $1/1000}')")
  else
    tok_display="${total_tokens}"
  fi
  if [ -n "$used_pct" ]; then
    used_int=$(printf "%.0f" "$used_pct")
    right="$right $(printf "\033[2m%s tok (%s%% ctx)\033[0m" "$tok_display" "$used_int")"
  else
    right="$right $(printf "\033[2m%s tok\033[0m" "$tok_display")"
  fi
elif [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  right="$right $(printf "\033[2mctx:%s%%\033[0m" "$used_int")"
fi

# Rate limit usage (Claude.ai subscription): 5-hour and/or 7-day when available
rate_str=""
if [ -n "$five_hour" ]; then
  rate_str="5h:$(printf '%.0f' "$five_hour")%"
fi
if [ -n "$seven_day" ]; then
  [ -n "$rate_str" ] && rate_str="$rate_str "
  rate_str="${rate_str}7d:$(printf '%.0f' "$seven_day")%"
fi
if [ -n "$rate_str" ]; then
  right="$right $(printf "\033[2m[%s]\033[0m" "$rate_str")"
fi

right="$right $(printf "\033[2m%s\033[0m" "$(date +%H:%M)")"

printf "%s  %s\n" "$left" "$right"
