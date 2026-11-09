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
  "get layouts")
    printf '{"layouts":[{"symbol":"T","name":"tile"},{"symbol":"M","name":"monocle"}]}\n'
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
export OJUNY_TEST_COUNT=5
export OJUNY_TEST_SYMBOL=T
printf 'T\n' > "$OJUNY_TEST_STATE"

bash "$script" 5 monocle 1

cache="$tmp/run/ojuny-overflow-layout/eDP-1_1"
[ "$(cat "$cache")" = "tile" ]
[ "$(tail -n 1 "$tmp/dispatch")" = "setlayout,monocle" ]

: > "$tmp/dispatch"
export OJUNY_TEST_COUNT=4
export OJUNY_TEST_SYMBOL=M
printf 'M\n' > "$OJUNY_TEST_STATE"

bash "$script" 5 monocle 1

[ ! -f "$cache" ]
[ "$(tail -n 1 "$tmp/dispatch")" = "setlayout,tile" ]

printf 'overflow layout check ok\n'
