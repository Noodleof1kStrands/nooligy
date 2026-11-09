#!/usr/bin/env bash
set -euo pipefail

threshold="${1:?window count is required}"
overflow_layout="${2:?overflow layout is required}"
restart_interval="${3:-1}"

cache_dir="${XDG_RUNTIME_DIR:-/tmp}/ojuny-overflow-layout"
mkdir -p "$cache_dir"

active_monitor() {
  mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .name' | head -n 1
}

tag_field() {
  local monitor="$1"
  local field="$2"
  mmsg get tags "$monitor" | jq -r --arg field "$field" '.tags[] | select(.is_active) | .[$field]' | head -n 1
}

layout_name() {
  local symbol="$1"
  mmsg get layouts | jq -r --arg symbol "$symbol" '.layouts[] | select(.symbol == $symbol) | .name' | head -n 1
}

tiled_count() {
  local monitor="$1"
  local tag="$2"
  mmsg get all-clients | jq -r --arg monitor "$monitor" --argjson tag "$tag" '
    [ .clients[]
      | select(.monitor == $monitor)
      | select(.tags | index($tag))
      | select(.is_floating | not)
    ] | length
  '
}

handle_state() {
  local state="$1"
  local monitor tag symbol current count cache original

  monitor="$(active_monitor)" || return 0
  [ -n "$monitor" ] || return 0

  tag="$(printf '%s' "$state" | jq -r --arg monitor "$monitor" '
    .all_tags[] | select(.monitor == $monitor) | .active_tags[0] // empty
  ' | head -n 1)"
  [ -n "$tag" ] || return 0

  symbol="$(printf '%s' "$state" | jq -r --arg monitor "$monitor" --argjson tag "$tag" '
    .all_tags[] | select(.monitor == $monitor)
    | .tags[] | select(.index == $tag) | .layout
  ' | head -n 1)"
  [ -n "$symbol" ] || return 0

  current="$(layout_name "$symbol")" || return 0
  [ -n "$current" ] || return 0

  count="$(tiled_count "$monitor" "$tag")" || return 0
  [ -n "$count" ] || return 0

  cache="$cache_dir/${monitor//[^A-Za-z0-9_.-]/_}_${tag}"

  if [ "$count" -lt "$threshold" ]; then
    if [ -f "$cache" ]; then
      original="$(cat "$cache")"
      if [ -n "$original" ]; then
        mmsg dispatch setlayout,"$original"
        if [ "$(layout_name "$(tag_field "$monitor" layout)")" = "$original" ]; then
          rm -f "$cache"
        fi
      else
        rm -f "$cache"
      fi
    fi
  elif [ "$current" != "$overflow_layout" ]; then
    if [ ! -f "$cache" ]; then
      printf '%s\n' "$current" > "$cache"
    fi
    mmsg dispatch setlayout,"$overflow_layout"
  fi
}

seen_events=0

while :; do
  while IFS= read -r state; do
    [ -n "$state" ] || continue
    handle_state "$state"
    seen_events=$((seen_events + 1))

    if [ "${OJUNY_OVERFLOW_ONCE:-0}" != "0" ] && [ "$seen_events" -ge "${OJUNY_OVERFLOW_ONCE}" ]; then
      exit 0
    fi
  done < <(
    mmsg watch all-tags |
      stdbuf -oL uniq
  )

  sleep "$restart_interval"
done
