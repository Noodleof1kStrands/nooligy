# Hardware coverage

Generated from the `hardwareProfiles` table in
`modules/07-system/10-hardware-profile.nix`. States are `tested`,
`untested` and `unsupported`. This is a test set, not a certification
program.

The maintainer's test hardware is the Microsoft Surface Go and the Lenovo
ThinkPad X1 Carbon. No row is marked `tested` in this pass because no build
was run. Patterns match the lowercased `smbios.system.product` or
`smbios.system.version` string.

| Vendor | Product pattern | Profile | State |
|--------|-----------------|---------|-------|
| apple | `.*macbookpro.*` | `apple-macbook-pro` | untested |
| apple | `.*macbookair7,.*` | `apple-macbook-air-3` | untested |
| apple | `.*macbookair8,.*` | `apple-macbook-air-4` | untested |
| apple | `.*macbookair9,.*` | `apple-macbook-air-5` | untested |
| apple | `.*macmini.*` | `apple-macmini-4-1` | untested |
| asus | `.*g533q.*` | `asus-rog-strix-g533q` | untested |
| asus | `.*g533zw.*` | `asus-rog-strix-g533zw` | untested |
| asus | `.*ga401iv.*` | `asus-zephyrus-ga401iv` | untested |
| asus | `.*ga401.*` | `asus-zephyrus-ga401` | untested |
| asus | `.*ga402x.*` | `asus-zephyrus-ga402x-amdgpu` | untested |
| asus | `.*ga402.*` | `asus-zephyrus-ga402` | untested |
| asus | `.*hn7306eac.*` | `asus-proart-px13-hn7306eac` | untested |
| asus | `.*px13.*` | `asus-proart-px13` | untested |
| asus | `.*g513.*` | `asus-rog-strix-g513im` | untested |
| asus | `.*g713.*` | `asus-rog-strix-g713ie` | untested |
| asus | `.*g733.*` | `asus-rog-strix-g733qs` | untested |
| asus | `.*ga503.*` | `asus-zephyrus-ga503` | untested |
| asus | `.*gu603.*` | `asus-zephyrus-gu603h` | untested |
| asus | `.*ux371.*` | `asus-zenbook-ux371` | untested |
| asus | `.*ux535.*` | `asus-zenbook-ux535` | untested |
| asus | `.*fx506.*` | `asus-fx506hm` | untested |
| asus | `.*fa506.*` | `asus-fa506nc` | untested |
| asus | `.*fa507.*` | `asus-fa507nv` | untested |
| asus | `.*rog strix x570.*` | `asus-rog-strix-x570e` | untested |
| asus | `.*rog ally rc71l.*` | `asus-ally-rc71l` | untested |
| asus | `.*gv302x.*` | `asus-flow-gv302x-amdgpu` | untested |
| asus | `.*gz301vu.*` | `asus-flow-gz301vu` | untested |
| asus | `.*gl552vw.*` | `asus-rog-gl552vw` | untested |
| asus | `.*ga502.*` | `asus-zephyrus-ga502` | untested |
| asus | `.*gu605cw.*` | `asus-zephyrus-gu605cw` | untested |
| asus | `.*gu605my.*` | `asus-zephyrus-gu605my` | untested |
| asus | `.*pro ws x570.*` | `asus-pro-ws-x570-ace` | untested |
| asus | `.*b9406.*` | `ojuny-asus-expertbook-b9406` | untested |
| asus | `.*ux5406aa.*` | `ojuny-asus-zenbook-ux5406aa` | untested |
| asus | `.*gz302.*` | `ojuny-asus-rog-z13-gz302` | untested |
| chuwi | `.*minibook x.*` | `chuwi-minibook-x` | untested |
| dell | `.*xps 13 9370.*` | `dell-xps-13-9370` | untested |
| dell | `.*xps 13 9380.*` | `dell-xps-13-9380` | untested |
| dell | `.*xps 13 9300.*` | `dell-xps-13-9300` | untested |
| dell | `.*xps 13 9310.*` | `dell-xps-13-9310` | untested |
| dell | `.*xps 13 9315.*` | `dell-xps-13-9315` | untested |
| dell | `.*xps 13 9343.*` | `dell-xps-13-9343` | untested |
| dell | `.*xps 15 9500.*` | `dell-xps-15-9500` | untested |
| dell | `.*xps 15 9510.*` | `dell-xps-15-9510` | untested |
| dell | `.*xps 15 9520.*` | `dell-xps-15-9520` | untested |
| dell | `.*xps 15 9530.*` | `dell-xps-15-9530` | untested |
| dell | `.*xps 15 9550.*` | `dell-xps-15-9550` | untested |
| dell | `.*latitude 7420.*` | `dell-latitude-7420` | untested |
| dell | `.*latitude 7430.*` | `dell-latitude-7430` | untested |
| dell | `.*latitude 7490.*` | `dell-latitude-7490` | untested |
| dell | `.*precision 5560.*` | `dell-precision-5560` | untested |
| dell | `.*precision 5570.*` | `dell-precision-5570` | untested |
| dell | `.*xps 13 7390.*` | `dell-xps-13-7390` | untested |
| dell | `.*xps 13 9333.*` | `dell-xps-13-9333` | untested |
| dell | `.*xps 13 9350.*` | `dell-xps-13-9350` | untested |
| dell | `.*xps 13 9360.*` | `dell-xps-13-9360` | untested |
| dell | `.*xps 15 7590.*` | `dell-xps-15-7590` | untested |
| dell | `.*xps 15 9560.*` | `dell-xps-15-9560-nvidia` | untested |
| dell | `.*xps 15 9570.*` | `dell-xps-15-9570-nvidia` | untested |
| dell | `.*xps 17 9700.*` | `dell-xps-17-9700-intel` | untested |
| dell | `.*xps 17 9710.*` | `dell-xps-17-9710-intel` | untested |
| framework | `.*laptop 13.*7040.*` | `framework-13-7040-amd` | untested |
| framework | `.*laptop 13.*12th.*` | `framework-12th-gen-intel` | untested |
| framework | `.*laptop 13.*11th.*` | `framework-11th-gen-intel` | untested |
| framework | `.*laptop 13.*13th.*` | `framework-13th-gen-intel` | untested |
| framework | `.*laptop 13.*core ultra.*1.*` | `framework-intel-core-ultra-series1` | untested |
| framework | `.*laptop 13.*ai 300.*` | `framework-amd-ai-300-series` | untested |
| framework | `.*laptop 16.*7040.*` | `framework-16-7040-amd` | untested |
| framework | `.*laptop 16.*ai 300.*` | `framework-16-amd-ai-300-series` | untested |
| framework | `.*laptop 12.*13th.*` | `framework-12-13th-gen-intel` | untested |
| framework | `.*laptop 13.*core ultra.*3.*` | `framework-intel-core-ultra-series3` | untested |
| framework | `.*framework desktop.*` | `framework-desktop-amd-ai-max-300-series` | untested |
| gigabyte | `.*b550.*` | `gigabyte-b550` | untested |
| gigabyte | `.*b650.*` | `gigabyte-b650` | untested |
| google | `.*pixelbook.*` | `google-pixelbook` | untested |
| google | `.*brya.*` | `google-brya` | untested |
| google | `.*rex.*` | `google-rex` | untested |
| gpd | `.*pocket 3.*` | `gpd-pocket-3` | untested |
| gpd | `.*pocket 4.*` | `gpd-pocket-4` | untested |
| gpd | `.*win 2.*` | `gpd-win-2` | untested |
| gpd | `.*win max 2.*` | `gpd-win-max-2-2023` | untested |
| gpd | `.*win mini.*` | `gpd-win-mini-2024` | untested |
| hp | `.*elitebook 830 g6.*` | `hp-elitebook-830g6` | untested |
| hp | `.*elitebook 845 g7.*` | `hp-elitebook-845g7` | untested |
| hp | `.*elitebook 845 g8.*` | `hp-elitebook-845g8` | untested |
| hp | `.*elitebook 845 g9.*` | `hp-elitebook-845g9` | untested |
| hp | `.*probook 440 g5.*` | `hp-probook-440G5` | untested |
| hp | `.*probook 460 g11.*` | `hp-probook-460G11` | untested |
| hp | `.*laptop 14s.*` | `hp-laptop-14s-dq2024nf` | untested |
| hp | `.*laptop 15s.*` | `hp-laptop-15s-fq1xxx` | untested |
| hp | `.*omen 14.*` | `omen-14-fb0798ng` | untested |
| hp | `.*omen 16.*` | `omen-16-n0005ne` | untested |
| huawei | `.*machc.*` | `huawei-machc-wa` | untested |
| intel | `.*nuc.*` | `intel-nuc-12wshi7` | untested |
| lenovo | `.*x1 carbon.*7th.*` | `lenovo-thinkpad-x1-7th-gen` | untested |
| lenovo | `.*x1 carbon.*9th.*` | `lenovo-thinkpad-x1-9th-gen` | untested |
| lenovo | `.*x1 carbon.*10th.*` | `lenovo-thinkpad-x1-10th-gen` | untested |
| lenovo | `.*x1 carbon.*11th.*` | `lenovo-thinkpad-x1-11th-gen` | untested |
| lenovo | `.*20qd.*` | `lenovo-thinkpad-x1-7th-gen` | untested |
| lenovo | `.*20xw.*` | `lenovo-thinkpad-x1-9th-gen` | untested |
| lenovo | `.*21cb.*` | `lenovo-thinkpad-x1-10th-gen` | untested |
| lenovo | `.*21hm.*` | `lenovo-thinkpad-x1-11th-gen` | untested |
| lenovo | `.*thinkpad x1 carbon.*` | `lenovo-thinkpad-x1` | untested |
| lenovo | `.*thinkpad t14.*gen 1.*` | `lenovo-thinkpad-t14-intel-gen1` | untested |
| lenovo | `.*thinkpad t14s.*` | `lenovo-thinkpad-t14s` | untested |
| lenovo | `.*thinkpad x13.*` | `lenovo-thinkpad-x13-intel` | untested |
| lenovo | `.*yoga 7 14arh7.*` | `lenovo-yoga-7-14ARH7-amdgpu` | untested |
| lenovo | `.*yoga 6 13alc6.*` | `lenovo-yoga-6-13ALC6` | untested |
| lenovo | `.*ideapad 15ach6.*` | `lenovo-ideapad-15ach6` | untested |
| lenovo | `.*legion 5.*` | `lenovo-legion-15ach6h` | untested |
| lenovo | `.*yoga pro 7 14iah10.*` | `ojuny-lenovo-yoga-pro-7-14iah10` | untested |
| microsoft | `.*surface go.*` | `microsoft-surface-go` | untested |
| microsoft | `.*surface pro 3.*` | `microsoft-surface-pro-3` | untested |
| microsoft | `.*surface pro 9.*` | `microsoft-surface-pro-9` | untested |
| microsoft | `.*surface pro.*` | `microsoft-surface-pro-intel` | untested |
| microsoft | `.*surface laptop.*amd.*` | `microsoft-surface-laptop-amd` | untested |
| msi | `.*gf63.*` | `msi-gf63` | untested |
| msi | `.*gs60.*` | `msi-gs60` | untested |
| msi | `.*gl62.*` | `msi-gl62` | untested |
| msi | `.*gl65.*` | `msi-gl65-10SDR-492` | untested |
| msi | `.*prestige 15.*` | `msi-prestige-15-a10sc` | untested |
| msi | `.*b550.*` | `msi-b550-tomahawk` | untested |
| panasonic | `.*cf-lx3.*` | `letsnote-cf-lx3` | untested |
| panasonic | `.*cf-lx4.*` | `letsnote-cf-lx4` | untested |
| purism | `.*librem 13.*` | `purism-librem-13v3` | untested |
| purism | `.*librem 15.*` | `purism-librem-15v3` | untested |
| razer | `.*blade 14.*` | `razer-blade-14-RZ09-0530` | untested |
| samsung | `.*np900x3c.*` | `samsung-np900x3c` | unsupported |
| slimbook | `.*hero.*` | `slimbook-hero-rpl-rtx` | untested |
| starlabs | `.*starlite.*` | `starlabs-starlite-i5` | untested |
| system76 | `.*gaze.*` | `system76-gaze18` | untested |
| system76 | `.*galago.*` | `system76-galp5-1650` | untested |
| system76 | `.*darter.*` | `system76-darp6` | untested |
| system76 | `.*thelio.*` | `system76-thelio-mega` | untested |
| system76 | `.*` | `system76` | untested |
| toshiba | `.*satellite.*` | `toshiba-swanky` | unsupported |
| tuxedo | `.*aura 15.*` | `tuxedo-aura-15-gen1` | untested |
| tuxedo | `.*infinitybook.*14.*gen 9.*intel.*` | `tuxedo-infinitybook-pro14-gen9-intel` | untested |
| tuxedo | `.*infinitybook.*14.*gen 9.*amd.*` | `tuxedo-infinitybook-pro14-gen9-amd` | untested |
| tuxedo | `.*infinitybook.*14.*gen 10.*amd.*` | `tuxedo-infinitybook-pro14-gen10-amd` | untested |
| tuxedo | `.*infinitybook.*15.*gen 10.*amd.*` | `tuxedo-infinitybook-pro15-gen10-amd` | untested |
| tuxedo | `.*pulse 14.*` | `tuxedo-pulse-14-gen3` | untested |
| tuxedo | `.*pulse 15.*` | `tuxedo-pulse-15-gen2` | untested |
| xiaomi | `.*redmibook 15.*` | `xiaomi-redmibook-15-pro-2021` | untested |
| xiaomi | `.*redmibook 16.*` | `xiaomi-redmibook-16-pro-2024` | untested |

`tested` means the profile was built and booted on that model.
`untested` means the profile is offered in the dropdown but has not been
verified in this repository. It is a nixos-hardware profile, or an Ojuny quirk
profile for a model with no upstream profile.
`unsupported` means a profile exists but the template does not select it
automatically or offer it in the dropdown.

## GPU ownership

`modules/07-system/10-hardware-profile.nix` also carries `gpuProfiles`.
Each entry names the layouts the profile supports and, where nixos-hardware
splits the model into GPU variants, the variant slug to import. A profile
with `owns = true` imports its own video drivers, PRIME bus IDs and VA-API
packages. The Graphics page then stops emitting those definitions, so the
upstream module owns them without a priority conflict.

The Graphics page target `auto` reads `hardware.graphics_card` from the
facter report. The key is optional: `nixos-facter` omits it on machines
with no classifiable PCI display controller. When it is absent, `auto`
falls back to the selected profile's layout and then to `unknown`, which
resolves to `none`. The concrete targets remain manual overrides.

## Omarchy x86 parity

Omarchy applies hardware fixes by DMI predicate rather than by profile.
The following x86 devices are covered by an Ojuny profile or are recorded
as blocked.

| Omarchy device | Ojuny status |
|----------------|--------------|
| ASUS ROG family | Covered by the ROG Strix, Zephyrus, Flow and Ally rows |
| ASUS ProArt PX13 HN7306EAC | Covered by `asus-proart-px13-hn7306eac` |
| ASUS ExpertBook B9406 | Covered by `ojuny-asus-expertbook-b9406` |
| ASUS Zenbook UX5406AA | Covered by `ojuny-asus-zenbook-ux5406aa` |
| ASUS ROG Flow Z13 GZ302 | Covered by `ojuny-asus-rog-z13-gz302` |
| ASUS ProArt P14 H7407BA | Out of scope: NVIDIA N1x is aarch64 |
| Dell XPS 13 DX13260 and XPS 14/16 2026 | Blocked: no nixos-hardware profile; sidecar amplifier, Cirrus firmware, haptic touchpad and speaker tuning packages are not in nixpkgs |
| Framework 16 | Covered by `framework-16-7040-amd` and `framework-16-amd-ai-300-series` |
| Framework 13 AMD audio | Covered by the AMD common profile and its audio enhancement options |
| Lenovo Yoga Pro 7 14IAH10 | Covered by `ojuny-lenovo-yoga-pro-7-14iah10` |
| Lenovo Yoga Slim 7x and ThinkPad T14s Gen 6 | Out of scope: aarch64 |
| Microsoft Surface | Covered by the Surface Go, Pro 3, Pro 9, Pro Intel and Laptop AMD rows |
| Intel Macs and T2 | Partially covered by the MacBook rows; `apple-t2` is not selected |
| Generic Intel laptops | Blocked: thermald, lpmd, SOF, IPU7, Wi-Fi 7 EHT and FRED are not applied outside a model profile |
