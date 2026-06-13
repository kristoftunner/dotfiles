#!/bin/bash
# Statusline for Claude Code. Parses the JSON passed on stdin and prints
# cwd + context-window usage. Uses jq if available, otherwise python3.
input=$(cat)

if command -v jq >/dev/null 2>&1; then
  cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
  ctx_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
  tokens_used=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')

  if [ -n "$ctx_size" ]; then
    ctx_label=$(awk "BEGIN { printf \"%.0fk\", $ctx_size/1000 }")
  else
    ctx_label="?k"
  fi
  if [ -n "$tokens_used" ]; then
    used_label="$tokens_used"
  else
    used_label="?"
  fi

  printf "\033[01;34m%s\033[00m \033[0;33mctx:%s\033[00m \033[0;36mused:%s\033[00m" \
    "$cwd" "$ctx_label" "$used_label"
else
  printf '%s' "$input" | python3 -c '
import json, sys
d = json.load(sys.stdin)
ws = d.get("workspace") or {}
cwd = ws.get("current_dir") or d.get("cwd") or ""
cw = d.get("context_window") or {}
size = cw.get("context_window_size")
used = cw.get("total_input_tokens")
ctx = "%.0fk" % (size / 1000) if size else "?k"
used_label = str(used) if used is not None else "?"
sys.stdout.write("\033[01;34m%s\033[00m \033[0;33mctx:%s\033[00m \033[0;36mused:%s\033[00m" % (cwd, ctx, used_label))
'
fi
