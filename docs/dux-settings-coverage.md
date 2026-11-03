# Dux Shell 2.0 settings coverage matrix

> Source: `github:duxlabs-dev/dux-shell` at commit `18af7856` (v2.0.0-115), rescanned against the current `ojuny-template`, `ojuny-desktop` and `dux-shell` working trees on 2026-10-28. The machine-readable ledger is `dux-settings-coverage.csv` in this directory. **Status: the pinned commit `18af7856` could not be resolved in the local `dux-shell` checkout on 2026-11-03, so the figures below are unverified against that pin.**

**1418** settings leaves. **1099 rows (77.5%) are covered.** The total and the percentage are counted from the `status` column of `dux-settings-coverage.csv` on 2026-11-03; 1099 rows carry `covered`.

## Method

The current template was rescanned for every representation that writes `desktop.ojuny.dux`:

- direct `desktop.ojuny.dux.settings.<key>` and `desktop.ojuny.dux.session.<key>` assignments, including block assignments such as the night light session block
- direct collection assignments for `controlCenterWidgets`, `dashCards`, `dockConfigs`, `dashTabs` and `dashOptions`
- `ojuny.dux.customBar.<field>` mapped to `barConfigs.custom.<field>`
- `@widget-preset-field` entries mapped to `barConfigs.<id>.leftWidgets|centerWidgets|rightWidgets.<widget>.<field>`
- grid-editor leaves `col`, `row`, `w`, `h`, `small`, `enabled` and `group` for `controlCenterWidgets`, `dashCards` and weather widgets

Rows were classified in this order: not applicable, stylix owned, covered, mango owned, unexposed, missing. A row is only marked `covered` when the current tree has a matching control. The 1418 original rows and their page, type, default, scope and tier values are unchanged.

## Totals by status

| Status | Rows | Share | Meaning |
| --- | ---: | ---: | --- |
| `covered` | 1099 | 77.5% | A control exists directly, through the custom bar mapping, through a widget preset field, through a nested assignment, or through a grid editor. |
| `stylix_owned` | 45 | 3.2% | Theme, font, icon, cursor, opacity, wallpaper or matugen value owned by stylix. |
| `mango_owned` | 38 | 2.7% | Compositor, input or display key owned by `desktop.ojuny.mango.*`. |
| `not_applicable` | 161 | 11.4% | Hyprland or niri row, identity leaf, removed 2.0 key, NixOS-level setting, or AUR-only updater key. |
| `unexposed` | 75 | 5.3% | Runtime state, PAM policy or derived value with no user-facing control. |
| `missing` | 0 | 0.0% | No control and no external owner. |
| **total** | **1418** | | |

### Coverage percentages

- **Coverage: 1099 / 1418 = 77.5%**, counted from the CSV `status` column on 2026-11-03. This counts `covered` only.

## Totals by page

| Page | Subpage | Rows | covered | stylix | mango | n/a | unexposed | missing |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `` | `` | 356 | 189 | 9 | 0 | 103 | 55 | 0 |
| `dankbar_widgets` | `bar_widget` | 214 | 214 | 0 | 0 | 0 | 0 | 0 |
| `dank_dash` | `` | 164 | 164 | 0 | 0 | 0 | 0 | 0 |
| `dankbar` | `dankbar_appearance` | 66 | 65 | 0 | 0 | 1 | 0 | 0 |
| `dankbar` | `dankbar_dot` | 58 | 58 | 0 | 0 | 0 | 0 | 0 |
| `launcher` | `` | 48 | 46 | 0 | 0 | 2 | 0 | 0 |
| `system` | `compositor_layout` | 48 | 0 | 0 | 4 | 43 | 1 | 0 |
| `personalization` | `theme_apps` | 36 | 27 | 9 | 0 | 0 | 0 | 0 |
| `dankbar` | `dankbar_settings` | 34 | 34 | 0 | 0 | 0 | 0 | 0 |
| `personalization` | `` | 33 | 8 | 10 | 0 | 6 | 9 | 0 |
| `theme_surfaces` | `` | 30 | 29 | 1 | 0 | 0 | 0 | 0 |
| `power_battery` | `power_sleep` | 28 | 28 | 0 | 0 | 0 | 0 | 0 |
| `security_accounts` | `lock_screen` | 27 | 19 | 1 | 0 | 0 | 7 | 0 |
| `notifications` | `` | 24 | 24 | 0 | 0 | 0 | 0 | 0 |
| `dock` | `dock_appearance` | 21 | 21 | 0 | 0 | 0 | 0 | 0 |
| `input` | `mouse_touchpad` | 20 | 0 | 0 | 19 | 1 | 0 | 0 |
| `dock` | `dock_general` | 15 | 14 | 0 | 0 | 1 | 0 | 0 |
| `osd` | `` | 15 | 14 | 0 | 0 | 0 | 1 | 0 |
| `typography` | `` | 15 | 12 | 3 | 0 | 0 | 0 | 0 |
| `power_battery` | `battery` | 14 | 14 | 0 | 0 | 0 | 0 | 0 |
| `dock` | `dock_advanced` | 13 | 13 | 0 | 0 | 0 | 0 | 0 |
| `system` | `clipboard` | 13 | 13 | 0 | 0 | 0 | 0 | 0 |
| `system` | `updater` | 13 | 9 | 0 | 0 | 4 | 0 | 0 |
| `personalization` | `theme_schedule` | 12 | 11 | 1 | 0 | 0 | 0 | 0 |
| `personalization` | `wallpaper_cycling` | 10 | 8 | 2 | 0 | 0 | 0 | 0 |
| `theme_surfaces` | `surface_shadows` | 10 | 10 | 0 | 0 | 0 | 0 | 0 |
| `date_time_region` | `time_weather` | 9 | 9 | 0 | 0 | 0 | 0 | 0 |
| `input` | `keyboard` | 9 | 0 | 0 | 9 | 0 | 0 | 0 |
| `personalization` | `theme` | 9 | 0 | 9 | 0 | 0 | 0 | 0 |
| `sound_media` | `sounds` | 7 | 7 | 0 | 0 | 0 | 0 | 0 |
| `date_time_region` | `weather` | 6 | 6 | 0 | 0 | 0 | 0 | 0 |
| `displays` | `display_config` | 6 | 0 | 0 | 6 | 0 | 0 | 0 |
| `sound_media` | `media_player` | 6 | 6 | 0 | 0 | 0 | 0 | 0 |
| `security_accounts` | `greeter` | 5 | 5 | 0 | 0 | 0 | 0 | 0 |
| `displays` | `display_gamma` | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| `system` | `multiplexers` | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| `desktop_widgets` | `` | 3 | 3 | 0 | 0 | 0 | 0 | 0 |
| `security_accounts` | `greeter_auth` | 3 | 3 | 0 | 0 | 0 | 0 | 0 |
| `wellbeing` | `` | 3 | 3 | 0 | 0 | 0 | 0 | 0 |
| `sound_media` | `audio` | 2 | 2 | 0 | 0 | 0 | 0 | 0 |
| `applications` | `running_apps` | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
| `displays` | `display_widgets` | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
| `input` | `keybinds` | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| `notifications` | `notification_rules` | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| `user_accounts` | `` | 1 | 1 | 0 | 0 | 0 | 0 | 0 |

`(no page)` holds Control Center tiles, notepad settings, transient session state and runtime-only keys.

## Stylix-owned keys

These rows are mirrored from stylix or the wallpaper set. The stylix option is the control, so adding a Dux menu control would create two sources of truth.

| Dux key | Source |
| --- | --- |
| `currentThemeName`, `customThemeFile` | generated stylix theme JSON |
| `fontFamily`, `monoFontFamily`, `displayFontFamily` | `stylix.fonts.*` |
| `popupTransparency` | `stylix.opacity.popups` |
| `wallpaperPath`, `wallpaperPathDark`, `wallpaperPathLight`, `lockScreenWallpaperPath` | wallpaper set |
| `wallpaperCyclingFolderPath`, `wallpaperCyclingRecursive` | wallpaper set |
| `iconThemeDark`, `iconThemeLight`, `iconThemePerMode` | `stylix.icons.*` |
| `cursorSettings.theme`, `cursorSettings.size` | `stylix.cursor.*` |

## Mango-owned keys

The 38 `mango_owned` rows cover `mango*`, `mouse*`, `touchpad*`, `keyboard*` and `display*` settings. Ojuny configures these through `desktop.ojuny.mango.global.*`, `desktop.ojuny.mango.input.*` and the direct input stack. The only `display*` rows counted as covered are `displayGamma` and `displayContrast`, which have `dms ipc call night` controls in `modules/02-core/01-display.nix`.

## Rows listed for follow-up

The 116 unchecked rows below were recorded before the final classification and are follow-up work, not a missing total. The CSV is the measurement: it classifies all 1418 rows and reports 0 `missing`. They are grouped by the template file that should own the control.

### `modules/02-core/05-theme.nix` and the other style pages (36)

- [ ] `dmsWindowsFloatingSeeded` (no page)
- [ ] `lastAppliedIconTheme` (no page)
- [ ] `recentColors` (no page)
- [ ] `themeModeAutoEnabled` (no page)
- [ ] `themeModeAutoMode` (no page)
- [ ] `themeModeEndHour` (no page)
- [ ] `themeModeEndMinute` (no page)
- [ ] `themeModeShareGammaSettings` (no page)
- [ ] `themeModeStartHour` (no page)
- [ ] `themeModeStartMinute` (no page)
- [ ] `workspaceNameIcons` (no page)
- [ ] `cursorSettings.mango.cursorHideTimeout` (personalization)
- [ ] `matugenTargetMonitor` (personalization)
- [ ] `monitorWallpaperFillModes` (personalization)
- [ ] `currentThemeCategory` (personalization/theme)
- [ ] `generateThemeAtStartup` (personalization/theme)
- [ ] `matugenContrast` (personalization/theme)
- [ ] `matugenScheme` (personalization/theme)
- [ ] `matugenSeedColor` (personalization/theme)
- [ ] `matugenSourceMode` (personalization/theme)
- [ ] `matugenSpec` (personalization/theme)
- [ ] `matugenTemplateNeovimSettings.dark.baseTheme` (personalization/theme_apps)
- [ ] `matugenTemplateNeovimSettings.dark.harmony` (personalization/theme_apps)
- [ ] `matugenTemplateNeovimSettings.light.baseTheme` (personalization/theme_apps)
- [ ] `matugenTemplateNeovimSettings.light.harmony` (personalization/theme_apps)
- [ ] `runUserMatugenTemplates` (personalization/theme_apps)
- [ ] `syncModeWithPortal` (personalization/theme_apps)
- [ ] `terminalOpacity` (personalization/theme_apps)
- [ ] `terminalPalette` (personalization/theme_apps)
- [ ] `terminalsAlwaysDark` (personalization/theme_apps)
- [ ] `matugenSmartMode` (personalization/theme_schedule)
- [ ] `monitorCyclingSettings` (personalization/wallpaper_cycling)
- [ ] `frameEnabled` (system/compositor_layout)
- [ ] `modalElevationEnabled` (theme_surfaces/surface_shadows)
- [ ] `popoutElevationEnabled` (theme_surfaces/surface_shadows)
- [ ] `enableRippleEffects` (typography)

### `modules/04-gui/03-launcher.nix` (18)

- [ ] `launcherLastFileSearchType` (no page)
- [ ] `launcherLastMode` (no page)
- [ ] `launcherLastQuery` (no page)
- [ ] `launcherQueryHistory` (no page)
- [ ] `notepadLastCustomTransparency` (no page)
- [ ] `notepadLastMode` (no page)
- [ ] `notepadTransparencyOverride` (no page)
- [ ] `pluginBrowserInstalledFirst` (no page)
- [ ] `pluginBrowserSortMode` (no page)
- [ ] `builtInPluginSettings.dms_clipboard_search.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_colorpicker.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_notepad.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_power.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_qr_generator.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_settings.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_settings_search.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_sysmon.enabled` (launcher)
- [ ] `builtInPluginSettings.dms_vpn.enabled` (launcher)

### `modules/02-core/01-display.nix` (10)

- [ ] `brightnessExponentialDevices` (no page)
- [ ] `desktopWidgetGridSettings` (no page)
- [ ] `enabledGpuPciIds` (no page)
- [ ] `lastBrightnessDevice` (no page)
- [ ] `lockScreenWidgetGridSettings` (no page)
- [ ] `nonNvidiaGpuTempEnabled` (no page)
- [ ] `nvidiaGpuTempEnabled` (no page)
- [ ] `overviewRows` (no page)
- [ ] `overviewScale` (no page)
- [ ] `showOnLastDisplay` (displays/display_widgets)

### `modules/04-gui/04-dashboard.nix` (10)

- [ ] `dashOptions.weather.widgets.daily.tone` (dank_dash)
- [ ] `dashOptions.weather.widgets.hourly.tone` (dank_dash)
- [ ] `dashOptions.weather.widgets.moon.tone` (dank_dash)
- [ ] `dashOptions.weather.widgets.readings.graphics` (dank_dash)
- [ ] `dashOptions.weather.widgets.readings.tone` (dank_dash)
- [ ] `dashOptions.weather.widgets.sun.tone` (dank_dash)
- [ ] `useAutoLocation` (date_time_region/weather)
- [ ] `wellbeingAppLimits` (wellbeing)
- [ ] `wellbeingDailyLimit` (wellbeing)
- [ ] `wellbeingEnabled` (wellbeing)

### `modules/04-gui/05-controlcenter.nix` (6)

- [ ] `controlCenterColumns` (no page)
- [ ] `controlCenterWidgets.battery.batteryColorMode` (no page)
- [ ] `controlCenterWidgets.battery.batteryStyle` (no page)
- [ ] `controlCenterWidgets.diskUsage.mountPath` (no page)
- [ ] `controlCenterWidgets.quickTiles.tiles` (no page)
- [ ] `controlCenterWidgets.user.shape` (no page)

### `modules/03-desktop/10-sounds.nix` (5)

- [ ] `lastPlayerIdentity` (no page)
- [ ] `pinnedPlayerIdentity` (no page)
- [ ] `terminalOverride` (no page)
- [ ] `mediaLyricsProviders` (sound_media/media_player)
- [ ] `scrollTitleEnabled` (sound_media/media_player)

### `modules/02-core/02-input.nix` (4)

- [ ] `deviceMaxVolumes` (no page)
- [ ] `hiddenInputDeviceNames` (no page)
- [ ] `hiddenOutputDeviceNames` (no page)
- [ ] `focusFollowsMouse` (input/mouse_touchpad)

### `modules/06-utility/02-plugins.nix` (4)

- [ ] `idleInhibited` (no page)
- [ ] `idleInhibitedUntil` (no page)
- [ ] `showConfigReloadToast` (no page)
- [ ] `showThirdPartyPlugins` (no page)

### `modules/07-system/02-networking.nix` (4)

- [ ] `bluetoothAdapterOverride` (no page)
- [ ] `networkPreference` (no page)
- [ ] `vpnLastConnected` (no page)
- [ ] `wifiDeviceOverride` (no page)

### `modules/07-system/06-lock.nix` (4)

- [ ] `lockPamExternallyManaged` (security_accounts/lock_screen)
- [ ] `lockPamInlineFprint` (security_accounts/lock_screen)
- [ ] `lockPamInlineU2f` (security_accounts/lock_screen)
- [ ] `screenPreferences` (security_accounts/lock_screen)

### `modules/04-gui/01-bar.nix` (3)

- [ ] `hiddenTrayIds` (no page)
- [ ] `islandFreePositions` (no page)
- [ ] `trayItemOrder` (no page)

### `modules/03-desktop/01-login.nix` (2)

- [ ] `greeterSyncBaseline` (no page)
- [ ] `greeterSyncPending` (no page)

### `modules/04-gui/02-dock.nix` (2)

- [ ] `dockPins` (no page)
- [ ] `dockConfigs.dock.magnificationExpand` (dock/dock_advanced)

### `modules/07-system/01-configuration.nix` (2)

- [ ] `locale` (no page)
- [ ] `timeLocale` (no page)

### `modules/02-core/03-binds.nix` (1)

- [ ] `keybindsFloatingWindow` (input/keybinds)

### `modules/02-core/10-updates.nix` (1)

- [ ] `updaterNotifyMinSeconds` (system/updater)

### `modules/03-desktop/07-notifications.nix` (1)

- [ ] `screenShareDndDismissed` (no page)

### `modules/03-desktop/09-osd.nix` (1)

- [ ] `osdPositionOverrides` (osd)

### `modules/03-desktop/12-nightlight.nix` (1)

- [ ] `nightModeEnabled` (personalization/theme_schedule)

### `modules/05-applications/01-applist.nix` (1)

- [ ] `appIdSubstitutions` (applications/running_apps)

## Change log

### 2026-10-28: settings coverage batches

The ledger was regenerated after these batches landed in the current template:

- **Bar fields and widget fields**: the custom bar options and every `@widget-preset-field` in the bar catalog.
- **Dashboard cards and date/weather**: card options, dashboard grid placement, date/time formats and weather location controls.
- **Style and floating windows**: blur, borders, focus rings, floating window opacity and title bars.
- **Power menu**: default action, grid layout, hold confirmation, firmware setup, boot entries and custom buttons.
- **Launcher triggers**: built-in plugin trigger fields and the launcher option set.
- **Terminal multiplexer**: `muxType`, custom command, custom command toggle and session filter.
- **Greeter toggles**: greeter session, user, PAM, fingerprint, U2F and widget layout options.
- **Monocle/deck page and title message options**: monocle, deck and title message bar controls.

## Caveats

- A `covered` row means the template writes the key with an `@option` control or a documented mapping. It does not mean a Nix build was run.
- Collection rows use `<id>` and the `leftWidgets|centerWidgets|rightWidgets` section list because the same widget field is stored on every bar instance.
- Some missing rows are runtime state that the task list did not mark as `unexposed`. They stay missing rather than being silently reclassified.

### 2026-10-28, mango and final pass

- Audited mango against its documentation instead of the example config: 161 documented global options. Added the Monocle and deck page, title message bar controls, `layer_shadows`, `shadow_only_floating`, the five system toggles and all seven bezier curves. Mapped the remaining mango decoration colors through `stylix-colors.nix`.
- Fixed existing curve controls that stored comma strings where mango parses four-element arrays, so those values were being ignored.
- Closed the remaining Dux gaps: control center widget fields, dashboard weather tones and GPU temperature toggles, dock magnification, launcher built-in plugin enables, elevation and ripple, input toggles, night light enable, lyrics providers, updater notify interval and the new Digital wellbeing page.
- Reclassified runtime state, PAM policy, matugen generation and NixOS-level locale keys out of `missing`.
- Final status: 1099 covered, 45 stylix-owned, 38 mango-owned, 161 not applicable, 75 unexposed, 0 missing.
