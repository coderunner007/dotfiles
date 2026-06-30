#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "unknown"')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
USAGE=$(echo "$input" | jq '.context_window.current_usage // empty')

# Directory and git branch
DIR="${PWD/#$HOME/~}"
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Build location segment
if [ -n "$GIT_BRANCH" ]; then
    LOCATION="[$DIR][$GIT_BRANCH]"
else
    LOCATION="[$DIR]"
fi

# Token and context stats
TOKENS_OUT="? tokens"
CTX_PCT_OUT="?% ctx"
REMAINING_OUT="? left"

if [ -n "$USAGE" ] && [ "$CONTEXT_SIZE" != "0" ] && [ "$CONTEXT_SIZE" != "null" ]; then
    CURRENT=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    if [ -n "$CURRENT" ] && [ "$CURRENT" != "null" ]; then
        TOKENS_K=$((CURRENT / 1000))
        if [ "$TOKENS_K" -gt 0 ]; then
            TOKENS_OUT="${TOKENS_K}k tokens"
        else
            TOKENS_OUT="${CURRENT} tokens"
        fi

        PERCENT=$((CURRENT * 100 / CONTEXT_SIZE))
        REMAINING=$((CONTEXT_SIZE - CURRENT))
        REMAINING_K=$((REMAINING / 1000))

        CTX_PCT_OUT="${PERCENT}% ctx"
        REMAINING_OUT="${REMAINING_K}k left"
    fi
fi

echo "${LOCATION} | ${MODEL} | ${TOKENS_OUT} | ${CTX_PCT_OUT} | ${REMAINING_OUT}"
