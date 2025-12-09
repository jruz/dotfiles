#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
project=$(basename "$cwd")
session=$(echo "$input" | jq -r '.session_id' | cut -c1-8)
icon="$HOME/.claude/hooks/clawd-icon.png"

terminal-notifier \
  -message "Claude Code needs input" \
  -title "$project ($session)" \
  -contentImage "$icon" \
  -sound default
