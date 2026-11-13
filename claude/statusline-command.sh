#!/usr/bin/env bash

input=$(cat)

IFS=$'\x1f' read -r model effort dir ctx five five_reset week < <(
  echo "$input" | jq -r '[
    .model.display_name,
    (.effort.level // ""),
    .workspace.current_dir,
    (.context_window.used_percentage // "" | if . == "" then . else floor end),
    (.rate_limits.five_hour.used_percentage // "" | if . == "" then . else floor end),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // "" | if . == "" then . else floor end)
  ] | map(tostring) | join("\u001f")'
)

branch=""
if git -C "$dir" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

DIM=$'\033[2m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'
SEP="${DIM} │ ${RESET}"

# Color a percentage by how close it is to the limit.
pct() {
  local label=$1 value=$2 color=$DIM
  if [ "$value" -ge 80 ]; then color=$RED
  elif [ "$value" -ge 50 ]; then color=$YELLOW
  fi
  printf '%s%s %s%%%s' "$color" "$label" "$value" "$RESET"
}

out="${CYAN}${model}${RESET}"
[ -n "$effort" ] && out+="${DIM} ${effort}${RESET}"

out+="${SEP}${BLUE}$(basename "$dir")${RESET}"
[ -n "$branch" ] && out+=" ${GREEN}${branch}${RESET}"

usage=()
[ -n "$ctx" ] && usage+=("$(pct ctx "$ctx")")
if [ -n "$five" ]; then
  item=$(pct 5h "$five")
  if [ -n "$five_reset" ]; then
    mins=$(( (five_reset - $(date +%s)) / 60 ))
    [ "$mins" -gt 0 ] && item+="${DIM} ($((mins / 60))h$((mins % 60))m)${RESET}"
  fi
  usage+=("$item")
fi
[ -n "$week" ] && usage+=("$(pct 7d "$week")")

if [ ${#usage[@]} -gt 0 ]; then
  out+="$SEP"
  for i in "${!usage[@]}"; do
    [ "$i" -gt 0 ] && out+="${DIM} · ${RESET}"
    out+="${usage[$i]}"
  done
fi

printf '%s' "$out"
