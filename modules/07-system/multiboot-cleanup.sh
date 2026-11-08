helper_dir="${OJUNY_HELPER_DIR:?}"
entry_file="${OJUNY_ENTRY_FILE:?}"
boot_mount="${OJUNY_BOOT_MOUNT:-}"

if [ -d "$helper_dir" ]; then
    rm -rf "$helper_dir"
fi
if [ -f "$entry_file" ]; then
    rm -f "$entry_file"
fi
if [ -n "$boot_mount" ] && [ -d "$boot_mount/EFI/ojuny" ]; then
    rmdir "$boot_mount/EFI/ojuny" 2>/dev/null || true
fi
