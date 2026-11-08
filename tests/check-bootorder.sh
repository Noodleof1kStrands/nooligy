#!/usr/bin/env bash
# Exercise modules/07-system/bootorder.sh against fake firmware state.
set -uo pipefail

SCRIPT="${SCRIPT:-$(dirname "$0")/../modules/07-system/bootorder.sh}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/bin" "$WORK/state"
export SIM_STATE="$WORK/state"
export PATH="$WORK/bin:$PATH"
export OJUNY_BOOT_MOUNT=/boot
export OJUNY_RECOVERY_FILE="$WORK/recovery.efi"
touch "$OJUNY_RECOVERY_FILE"

OJUNY_UUID="11111111-1111-1111-1111-111111111111"
WIN_UUID="22222222-2222-2222-2222-222222222222"
LINUX_UUID="33333333-3333-3333-3333-333333333333"
USB_UUID="44444444-4444-4444-4444-444444444444"
FW_UUID="55555555-5555-5555-5555-555555555555"

cat >"$WORK/bin/findmnt" <<'EOF'
#!/bin/sh
printf '/dev/sda3\n'
EOF

cat >"$WORK/bin/lsblk" <<'EOF'
#!/bin/sh
case "$*" in
*PKNAME*) printf 'sda\n' ;;
*PARTN*) printf '3\n' ;;
esac
EOF

cat >"$WORK/bin/blkid" <<EOF
#!/bin/sh
printf '%s\n' "$OJUNY_UUID"
EOF

cat >"$WORK/bin/efibootmgr" <<'EOF'
#!/bin/sh
state="$SIM_STATE"
case "${1:-}" in
-v)
    printf 'BootCurrent: 0000\n'
    printf 'BootOrder: %s\n' "$(cat "$state/order")"
    cat "$state/entries"
    ;;
"")
    printf 'BootCurrent: 0000\n'
    printf 'BootOrder: %s\n' "$(cat "$state/order")"
    ;;
-o)
    printf '%s\n' "$2" >"$state/order"
    printf '%s\n' "$2" >>"$state/order_writes"
    ;;
-c)
    printf '%s\n' "$*" >>"$state/creates"
    ;;
esac
EOF
chmod +x "$WORK/bin/findmnt" "$WORK/bin/lsblk" "$WORK/bin/blkid" "$WORK/bin/efibootmgr"

declare -A LABEL NUMBER PATH_OF
LABEL[O]="Linux Boot Manager"
PATH_OF[O]="HD(1,GPT,$OJUNY_UUID,0x800,0x100000)/File(\\EFI\\systemd\\systemd-bootx64.efi)"
NUMBER[O]=0000
LABEL[R]="Ojuny Recovery"
PATH_OF[R]="HD(1,GPT,$OJUNY_UUID,0x100800,0x40000)/File(\\EFI\\ojuny\\recovery\\ojuny-recovery.efi)"
NUMBER[R]=0001
LABEL[W]="Windows Boot Manager"
PATH_OF[W]="HD(2,GPT,$WIN_UUID,0x800,0x64000)/File(\\EFI\\Microsoft\\Boot\\bootmgfw.efi)"
NUMBER[W]=0002
LABEL[L]="Ubuntu"
PATH_OF[L]="HD(3,GPT,$LINUX_UUID,0x800,0x100000)/File(\\EFI\\ubuntu\\shimx64.efi)"
NUMBER[L]=0003
LABEL[U]="UEFI: SanDisk"
PATH_OF[U]="USB(0,0)/HD(1,GPT,$USB_UUID,0x800,0x1000)/File(\\EFI\\BOOT\\BOOTX64.EFI)"
NUMBER[U]=0004
LABEL[N]="UEFI: PXE"
PATH_OF[N]="MAC(44332211,1)/IPv4(0.0.0.0,0,0)"
NUMBER[N]=0005
LABEL[X]="Firmware Update"
PATH_OF[X]="HD(4,GPT,$FW_UUID,0x800,0x1000)/File(\\EFI\\firmware\\update.efi)"
NUMBER[X]=0006

FAILED=0

fail() {
    printf 'FAIL: %s\n' "$*" >&2
    FAILED=$((FAILED + 1))
}

numbers_of() {
    local tokens="$1" result="" index token
    for ((index = 0; index < ${#tokens}; index++)); do
        token="${tokens:$index:1}"
        result="${result:+$result,}${NUMBER[$token]}"
    done
    printf '%s' "$result"
}

tokens_of() {
    local order="$1" result="" number token
    for number in ${order//,/ }; do
        for token in O R W L U N X; do
            if [ "${NUMBER[$token]}" = "$number" ]; then
                result="$result$token"
                break
            fi
        done
    done
    printf '%s' "$result"
}

run_scenario() {
    local name="$1" tokens="$2" expected="$3" recovery="${4:-true}"
    local index token

    : >"$WORK/state/entries"
    : >"$WORK/state/creates"
    : >"$WORK/state/order_writes"
    for ((index = 0; index < ${#tokens}; index++)); do
        token="${tokens:$index:1}"
        printf 'Boot%s* %s\t%s\n' "${NUMBER[$token]}" "${LABEL[$token]}" "${PATH_OF[$token]}" \
            >>"$WORK/state/entries"
    done
    numbers_of "$tokens" >"$WORK/state/order"

    printf '%s: ' "$name"
    OJUNY_RECOVERY_ENABLED="$recovery" bash "$SCRIPT"
    local actual
    actual="$(tokens_of "$(cat "$WORK/state/order")")"
    if [ "$actual" = "$expected" ]; then
        printf '%s\n' "$actual"
    else
        printf '%s (expected %s)\n' "$actual" "$expected"
        fail "expected $expected, got $actual"
    fi

    local position external
    for ((position = 0; position < ${#tokens}; position++)); do
        external="${tokens:$position:1}"
        case "$external" in
        U | N | X)
            [ "${actual:$position:1}" = "$external" ] ||
                fail "$external moved from position $((position + 1))"
            ;;
        esac
    done

    : >"$WORK/state/order_writes"
    : >"$WORK/state/creates"
    OJUNY_RECOVERY_ENABLED="$recovery" bash "$SCRIPT"
    [ ! -s "$WORK/state/order_writes" ] || fail "second run reordered again"
    [ "$(tokens_of "$(cat "$WORK/state/order")")" = "$expected" ] || fail "order changed on second run"
}

run_scenario "windows, ojuny, recovery" WOR ORW
run_scenario "usb, windows, ojuny, recovery" UWOR UORW
run_scenario "windows, usb, ojuny, recovery" WUOR OURW
run_scenario "already correct" ORWU ORWU
run_scenario "recovery before ojuny" ROW ORW
run_scenario "ojuny, windows, recovery" OWR ORW
run_scenario "ubuntu, windows, ojuny, recovery, usb, pxe" LWORUN ORLWUN
run_scenario "usb, windows, recovery, ojuny, pxe" UWRON UORWN
run_scenario "unknown entry between windows and ojuny" WXOR OXRW
run_scenario "recovery disabled, windows, ojuny, usb" WOU OWU false
run_scenario "recovery disabled, already correct" OW OW false
run_scenario "recovery disabled, stale recovery entry" WRO ORW false
run_scenario "ojuny entry missing" WU WU
run_scenario "only ojuny and recovery" RO OR
run_scenario "usb, ojuny, recovery, ubuntu, windows, pxe" UORLWN UORLWN

if [ "$FAILED" -eq 0 ]; then
    printf 'all scenarios passed\n'
else
    printf '%s checks failed\n' "$FAILED" >&2
    exit 1
fi
