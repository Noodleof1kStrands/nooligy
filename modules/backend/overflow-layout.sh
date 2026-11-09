#!/usr/bin/env bash
set -euo pipefail

threshold="${1:?window count is required}"
overflow_layout="${2:?overflow layout is required}"
interval="${3:-1}"

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

while :; do
  if ! monitor="$(active_monitor)" || [ -z "$monitor" ]; then
    sleep "$interval"
    continue
  fi

  tag="$(tag_field "$monitor" index)"
  count="$(tag_field "$monitor" client_count)"
  symbol="$(tag_field "$monitor" layout)"
  current="$(layout_name "$symbol")"

  if [ -z "$tag" ] || [ -z "$count" ] || [ -z "$current" ]; then
    sleep "$interval"
    continue
  fi

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

  if [ "${OJUNY_OVERFLOW_ONCE:-0}" = "1" ]; then
    exit 0
  fi

  sleep "$interval"
done
