#!/usr/bin/env bash
set -euo pipefail

script="${1:?overflow script path is required}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin" "$tmp/run"

cat > "$tmp/bin/mmsg" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
case "$1 $2" in
  "get all-monitors")
    printf '{"monitors":[{"name":"eDP-1","active":true}]}\n'
    ;;
  "get tags")
    symbol="$(cat "${OJUNY_TEST_STATE}" 2>/dev/null || printf '%s' "${OJUNY_TEST_SYMBOL}")"
    printf '{"monitor":"%s","tags":[{"index":1,"is_active":true,"client_count":%s,"layout":"%s"}]}\n' \
      "$3" "${OJUNY_TEST_COUNT}" "$symbol"
    ;;
  "get all-clients")
    printf '{"clients":['
    first=1
    for _ in $(seq 1 "${OJUNY_TEST_COUNT}"); do
      [ "$first" = 1 ] || printf ','
      first=0
      printf '{"monitor":"eDP-1","tags":[1],"is_floating":false}'
    done
    for _ in $(seq 1 "${OJUNY_TEST_FLOATING}"); do
      [ "$first" = 1 ] || printf ','
      first=0
      printf '{"monitor":"eDP-1","tags":[1],"is_floating":true}'
    done
    printf ']}\n'
    ;;
  "get layouts")
    printf '{"layouts":[{"symbol":"T","name":"tile"},{"symbol":"M","name":"monocle"}]}\n'
    ;;
  "watch all-tags")
    symbol="$(cat "${OJUNY_TEST_STATE}" 2>/dev/null || printf '%s' "${OJUNY_TEST_SYMBOL}")"
    for _ in $(seq 1 "${OJUNY_TEST_WATCH_EVENTS:-1}"); do
      printf '{"all_tags":[{"monitor":"eDP-1","active_tags":[1],"tags":[{"index":1,"is_active":true,"client_count":%s,"layout":"%s"}]}]}\n' \
        "${OJUNY_TEST_COUNT}" "$symbol"
    done
    ;;
  "dispatch "*)
    printf '%s\n' "$2" >> "${OJUNY_TEST_DISPATCH_LOG}"
    case "$2" in
      "setlayout,tile") printf 'T\n' > "${OJUNY_TEST_STATE}" ;;
      "setlayout,monocle") printf 'M\n' > "${OJUNY_TEST_STATE}" ;;
    esac
    ;;
  *)
    exit 1
    ;;
esac
MOCK
chmod +x "$tmp/bin/mmsg"

export PATH="$tmp/bin:$PATH"
export XDG_RUNTIME_DIR="$tmp/run"
export OJUNY_OVERFLOW_ONCE=1
export OJUNY_TEST_DISPATCH_LOG="$tmp/dispatch"
export OJUNY_TEST_STATE="$tmp/state"
export OJUNY_TEST_FLOATING=2
export OJUNY_TEST_SYMBOL=T
export OJUNY_TEST_WATCH_EVENTS=2
export OJUNY_OVERFLOW_ONCE=2
printf 'T\n' > "$OJUNY_TEST_STATE"
: > "$OJUNY_TEST_DISPATCH_LOG"

cache="$tmp/run/ojuny-overflow-layout/eDP-1_1"

export OJUNY_TEST_COUNT=4
bash "$script" 5 monocle 1
[ ! -f "$cache" ]
[ ! -s "$tmp/dispatch" ]

export OJUNY_TEST_COUNT=5
bash "$script" 5 monocle 1
[ "$(cat "$cache")" = "tile" ]
[ "$(wc -l < "$tmp/dispatch")" -eq 1 ]
[ "$(tail -n 1 "$tmp/dispatch")" = "setlayout,monocle" ]

: > "$tmp/dispatch"
export OJUNY_TEST_COUNT=4
export OJUNY_TEST_SYMBOL=M
printf 'M\n' > "$OJUNY_TEST_STATE"

bash "$script" 5 monocle 1

[ ! -f "$cache" ]
[ "$(wc -l < "$tmp/dispatch")" -eq 1 ]
[ "$(tail -n 1 "$tmp/dispatch")" = "setlayout,tile" ]

printf 'overflow layout check ok\n'
