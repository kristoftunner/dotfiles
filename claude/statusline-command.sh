#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
tokens_used=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

# Format context window size as e.g. "200k"
if [ -n "$ctx_size" ]; then
  ctx_label=$(awk "BEGIN { printf \"%.0fk\", $ctx_size/1000 }")
else
  ctx_label="?k"
fi

# Format tokens used as e.g. "12345" or "?" before first API call
if [ -n "$tokens_used" ]; then
  used_label="$tokens_used"
else
  used_label="?"
fi

printf "\033[01;34m%s\033[00m \033[0;33mctx:%s\033[00m \033[0;36mused:%s\033[00m" \
  "$cwd" "$ctx_label" "$used_label"
