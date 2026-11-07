#!/usr/bin/env bash
set -euo pipefail

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Disk image" "$1"
  else
    printf '%s\n' "$1" >&2
  fi
}

fail() {
  notify "$1"
  exit 1
}

[ "$#" -eq 1 ] || fail "Usage: ojuny-mount-image <image>"

image="$1"
[ -f "$image" ] || fail "Not a file: $image"

if ! command -v udisksctl >/dev/null 2>&1; then
  fail "udisksctl is not installed"
fi

loop_output="$(udisksctl loop-setup --file "$image")" || fail "Could not attach $image"
loop_device="$(printf '%s\n' "$loop_output" | sed -n 's/.* as \(\/dev\/loop[0-9]*\).*/\1/p' | sed -n '1p')"
[ -n "$loop_device" ] || fail "Could not find the loop device for $image"

for ((attempt = 0; attempt < 20; attempt++)); do
  if [ -b "$loop_device" ]; then
    break
  fi
  sleep 0.1
done
[ -b "$loop_device" ] || fail "Loop device $loop_device did not appear"

mount_point="$(findmnt -n -o TARGET --source "$loop_device" 2>/dev/null | sed -n '1p' || true)"

if [ -z "$mount_point" ] && udisksctl mount --block-device "$loop_device" >/dev/null 2>&1; then
  mount_point="$(findmnt -n -o TARGET --source "$loop_device" 2>/dev/null | sed -n '1p' || true)"
fi

if [ -z "$mount_point" ]; then
  while IFS= read -r partition; do
    device="/dev/$partition"
    if udisksctl mount --block-device "$device" >/dev/null 2>&1; then
      mount_point="$(findmnt -n -o TARGET --source "$device" 2>/dev/null | sed -n '1p' || true)"
      if [ -n "$mount_point" ]; then
        break
      fi
    fi
  done < <(lsblk -ln -o NAME "$loop_device" | sed -n '2,$p')
fi

[ -n "$mount_point" ] || fail "Attached $loop_device but could not mount it"

if ! xdg-open "$mount_point" >/dev/null 2>&1; then
  notify "Mounted at $mount_point"
fi
