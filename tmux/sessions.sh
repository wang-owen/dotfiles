#!/usr/bin/env bash

self=$(realpath "$0")
gap=3
chrome=6
min_width=42

list() {
  local current
  current=$(tmux display -p '#{client_session}')
  tmux list-sessions -F '#{?session_last_attached,#{session_last_attached},0} #{session_windows} #{session_attached} #{session_name}' |
    sort -rn |
    while read -r _ windows attached name; do
      local info="$windows window"
      [ "$windows" = 1 ] || info+=s
      if [ "$name" = "$current" ]; then
        info+=" · current"
      elif [ "$attached" != 0 ]; then
        info+=" · attached"
      fi
      printf '%s\t\033[90m%s\033[0m\n' "$name" "$info"
    done
}

kill_session() {
  if [ "$1" = "$(tmux display -p '#{client_session}')" ]; then
    tmux switch-client -l 2>/dev/null || tmux switch-client -n
  fi
  tmux kill-session -t "=$1"
}

popup() {
  local rows name_w info_w width
  read -r rows name_w info_w < <(list | awk -F'\t' '
    { gsub(/\033\[[0-9;]*m/, "", $2); if (length($1) > n) n = length($1); if (length($2) > i) i = length($2) }
    END { print NR, n, i }')
  width=$(( name_w + gap + info_w + chrome ))
  tmux display-popup -c "$1" -E -B -w $(( width > min_width ? width : min_width )) -h $(( rows + 2 )) "$self" pick "$name_w"
}

hints() {
  while [ $# -gt 0 ]; do
    printf ' \033[1;39m%s\033[22;90m %s ' "$1" "$2"
    shift 2
  done
}

pick() {
  local browse search session
  browse=$(hints ↵ switch x kill / search q quit)
  search=$(hints ↵ switch esc back)
  session=$(list | fzf \
    --ansi --style full --no-preview --no-input --reverse --no-sort --track \
    --delimiter '\t' --nth 1 --accept-nth 1 --tabstop $(( $1 + gap )) \
    --info inline-right --info-command 'echo "$FZF_MATCH_COUNT/$FZF_TOTAL_COUNT"' --pointer '▌' --gutter ' ' --color 'pointer:bold,border:bright-black,label:bright-black' \
    --input-label ' search ' --list-label "$browse" --list-label-pos 0:bottom \
    --bind 'j:down,k:up,q:abort' \
    --bind "x:reload($self kill {1}; $self list)" \
    --bind "/:show-input+unbind(j,k,q,x,/)+change-list-label($search)" \
    --bind "esc:clear-query+transform:[ \"\$FZF_INPUT_STATE\" = hidden ] && echo abort || echo 'hide-input+rebind(j,k,q,x,/)+change-list-label($browse)'")
  [ -n "$session" ] && tmux switch-client -t "=$session"
}

case $1 in
  list) list ;;
  kill) kill_session "$2" ;;
  popup) popup "$2" || true ;;
  pick) pick "$2" ;;
esac
