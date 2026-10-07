#!/usr/bin/env bash
# Claude Code status line: model name, current directory, git branch, context remaining.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
dir=$(echo "$input" | jq -r '.workspace.current_dir')
dir_display=$(basename "$dir")

branch=""
if git -C "$dir" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
fi

remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Dimmed ANSI colors (suited for terminals using this status line's own dim palette)
COLOR_MODEL=$'\033[2;36m'   # dim cyan
COLOR_DIR=$'\033[2;34m'     # dim blue
COLOR_GIT=$'\033[2;32m'     # dim green
COLOR_CTX=$'\033[2;33m'     # dim yellow
RESET=$'\033[0m'

out="${COLOR_MODEL}${model}${RESET}"

if [ -n "$effort" ]; then
  out="${out} ${COLOR_MODEL}[${effort}]${RESET}"
fi

out="${out} ${COLOR_DIR}${dir_display}${RESET}"

if [ -n "$branch" ]; then
  out="${out} ${COLOR_GIT}(${branch})${RESET}"
fi

if [ -n "$remaining" ]; then
  out="${out} ${COLOR_CTX}${remaining}% left${RESET}"
fi

printf '%s' "$out"
