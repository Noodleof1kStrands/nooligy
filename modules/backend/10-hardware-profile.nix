{ self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;

  # Mirrored in scripts/regenerate-hardware.py.
  # tests/check-hardware-profile.py fails when the two tables differ.
  # Slugs checked against nixos-hardware 1b418b8f203e49a92f250f8babdd19af1b6f7a7f.
  # Order matters: the first row whose vendor and product or version pattern match wins.
  hardwareProfiles = [
    { vendor = "apple"; pattern = ".*macbookpro.*"; profile = "apple-macbook-pro"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair7,.*"; profile = "apple-macbook-air-3"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair8,.*"; profile = "apple-macbook-air-4"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macbookair9,.*"; profile = "apple-macbook-air-5"; state = "untested"; }
    { vendor = "apple"; pattern = ".*macmini.*"; profile = "apple-macmini-4-1"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g533q.*"; profile = "asus-rog-strix-g533q"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g533zw.*"; profile = "asus-rog-strix-g533zw"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga401iv.*"; profile = "asus-zephyrus-ga401iv"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga401.*"; profile = "asus-zephyrus-ga401"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga402x.*"; profile = "asus-zephyrus-ga402x-amdgpu"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga402.*"; profile = "asus-zephyrus-ga402"; state = "untested"; }
    { vendor = "asus"; pattern = ".*hn7306eac.*"; profile = "asus-proart-px13-hn7306eac"; state = "untested"; }
    { vendor = "asus"; pattern = ".*px13.*"; profile = "asus-proart-px13"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g513.*"; profile = "asus-rog-strix-g513im"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g713.*"; profile = "asus-rog-strix-g713ie"; state = "untested"; }
    { vendor = "asus"; pattern = ".*g733.*"; profile = "asus-rog-strix-g733qs"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga503.*"; profile = "asus-zephyrus-ga503"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gu603.*"; profile = "asus-zephyrus-gu603h"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ux371.*"; profile = "asus-zenbook-ux371"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ux535.*"; profile = "asus-zenbook-ux535"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fx506.*"; profile = "asus-fx506hm"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fa506.*"; profile = "asus-fa506nc"; state = "untested"; }
    { vendor = "asus"; pattern = ".*fa507.*"; profile = "asus-fa507nv"; state = "untested"; }
    { vendor = "asus"; pattern = ".*rog strix x570.*"; profile = "asus-rog-strix-x570e"; state = "untested"; }
    { vendor = "asus"; pattern = ".*rog ally rc71l.*"; profile = "asus-ally-rc71l"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gv302x.*"; profile = "asus-flow-gv302x-amdgpu"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gz301vu.*"; profile = "asus-flow-gz301vu"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gl552vw.*"; profile = "asus-rog-gl552vw"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ga502.*"; profile = "asus-zephyrus-ga502"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gu605cw.*"; profile = "asus-zephyrus-gu605cw"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gu605my.*"; profile = "asus-zephyrus-gu605my"; state = "untested"; }
    { vendor = "asus"; pattern = ".*pro ws x570.*"; profile = "asus-pro-ws-x570-ace"; state = "untested"; }
    { vendor = "asus"; pattern = ".*b9406.*"; profile = "ojuny-asus-expertbook-b9406"; state = "untested"; }
    { vendor = "asus"; pattern = ".*ux5406aa.*"; profile = "ojuny-asus-zenbook-ux5406aa"; state = "untested"; }
    { vendor = "asus"; pattern = ".*gz302.*"; profile = "ojuny-asus-rog-z13-gz302"; state = "untested"; }
    { vendor = "chuwi"; pattern = ".*minibook x.*"; profile = "chuwi-minibook-x"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9370.*"; profile = "dell-xps-13-9370"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9380.*"; profile = "dell-xps-13-9380"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9300.*"; profile = "dell-xps-13-9300"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9310.*"; profile = "dell-xps-13-9310"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9315.*"; profile = "dell-xps-13-9315"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9343.*"; profile = "dell-xps-13-9343"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9500.*"; profile = "dell-xps-15-9500"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9510.*"; profile = "dell-xps-15-9510"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9520.*"; profile = "dell-xps-15-9520"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9530.*"; profile = "dell-xps-15-9530"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9550.*"; profile = "dell-xps-15-9550"; state = "untested"; }
    { vendor = "dell"; pattern = ".*latitude 7420.*"; profile = "dell-latitude-7420"; state = "untested"; }
    { vendor = "dell"; pattern = ".*latitude 7430.*"; profile = "dell-latitude-7430"; state = "untested"; }
    { vendor = "dell"; pattern = ".*latitude 7490.*"; profile = "dell-latitude-7490"; state = "untested"; }
    { vendor = "dell"; pattern = ".*precision 5560.*"; profile = "dell-precision-5560"; state = "untested"; }
    { vendor = "dell"; pattern = ".*precision 5570.*"; profile = "dell-precision-5570"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 7390.*"; profile = "dell-xps-13-7390"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9333.*"; profile = "dell-xps-13-9333"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9350.*"; profile = "dell-xps-13-9350"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 13 9360.*"; profile = "dell-xps-13-9360"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 7590.*"; profile = "dell-xps-15-7590"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9560.*"; profile = "dell-xps-15-9560-nvidia"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 15 9570.*"; profile = "dell-xps-15-9570-nvidia"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 17 9700.*"; profile = "dell-xps-17-9700-intel"; state = "untested"; }
    { vendor = "dell"; pattern = ".*xps 17 9710.*"; profile = "dell-xps-17-9710-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*7040.*"; profile = "framework-13-7040-amd"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*12th.*"; profile = "framework-12th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*11th.*"; profile = "framework-11th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*13th.*"; profile = "framework-13th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*core ultra.*1.*"; profile = "framework-intel-core-ultra-series1"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*ai 300.*"; profile = "framework-amd-ai-300-series"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 16.*7040.*"; profile = "framework-16-7040-amd"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 16.*ai 300.*"; profile = "framework-16-amd-ai-300-series"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 12.*13th.*"; profile = "framework-12-13th-gen-intel"; state = "untested"; }
    { vendor = "framework"; pattern = ".*laptop 13.*core ultra.*3.*"; profile = "framework-intel-core-ultra-series3"; state = "untested"; }
    { vendor = "framework"; pattern = ".*framework desktop.*"; profile = "framework-desktop-amd-ai-max-300-series"; state = "untested"; }
    { vendor = "gigabyte"; pattern = ".*b550.*"; profile = "gigabyte-b550"; state = "untested"; }
    { vendor = "gigabyte"; pattern = ".*b650.*"; profile = "gigabyte-b650"; state = "untested"; }
    { vendor = "google"; pattern = ".*pixelbook.*"; profile = "google-pixelbook"; state = "untested"; }
    { vendor = "google"; pattern = ".*brya.*"; profile = "google-brya"; state = "untested"; }
    { vendor = "google"; pattern = ".*rex.*"; profile = "google-rex"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*pocket 3.*"; profile = "gpd-pocket-3"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*pocket 4.*"; profile = "gpd-pocket-4"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win 2.*"; profile = "gpd-win-2"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win max 2.*"; profile = "gpd-win-max-2-2023"; state = "untested"; }
    { vendor = "gpd"; pattern = ".*win mini.*"; profile = "gpd-win-mini-2024"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 830 g6.*"; profile = "hp-elitebook-830g6"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g7.*"; profile = "hp-elitebook-845g7"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g8.*"; profile = "hp-elitebook-845g8"; state = "untested"; }
    { vendor = "hp"; pattern = ".*elitebook 845 g9.*"; profile = "hp-elitebook-845g9"; state = "untested"; }
    { vendor = "hp"; pattern = ".*probook 440 g5.*"; profile = "hp-probook-440G5"; state = "untested"; }
    { vendor = "hp"; pattern = ".*probook 460 g11.*"; profile = "hp-probook-460G11"; state = "untested"; }
    { vendor = "hp"; pattern = ".*laptop 14s.*"; profile = "hp-laptop-14s-dq2024nf"; state = "untested"; }
    { vendor = "hp"; pattern = ".*laptop 15s.*"; profile = "hp-laptop-15s-fq1xxx"; state = "untested"; }
    { vendor = "hp"; pattern = ".*omen 14.*"; profile = "omen-14-fb0798ng"; state = "untested"; }
    { vendor = "hp"; pattern = ".*omen 16.*"; profile = "omen-16-n0005ne"; state = "untested"; }
    { vendor = "huawei"; pattern = ".*machc.*"; profile = "huawei-machc-wa"; state = "untested"; }
    { vendor = "intel"; pattern = ".*nuc.*"; profile = "intel-nuc-12wshi7"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*7th.*"; profile = "lenovo-thinkpad-x1-7th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*9th.*"; profile = "lenovo-thinkpad-x1-9th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*10th.*"; profile = "lenovo-thinkpad-x1-10th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*x1 carbon.*11th.*"; profile = "lenovo-thinkpad-x1-11th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*20qd.*"; profile = "lenovo-thinkpad-x1-7th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*20xw.*"; profile = "lenovo-thinkpad-x1-9th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*21cb.*"; profile = "lenovo-thinkpad-x1-10th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*21hm.*"; profile = "lenovo-thinkpad-x1-11th-gen"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad x1 carbon.*"; profile = "lenovo-thinkpad-x1"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad t14.*gen 1.*"; profile = "lenovo-thinkpad-t14-intel-gen1"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad t14s.*"; profile = "lenovo-thinkpad-t14s"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*thinkpad x13.*"; profile = "lenovo-thinkpad-x13-intel"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*yoga 7 14arh7.*"; profile = "lenovo-yoga-7-14ARH7-amdgpu"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*yoga 6 13alc6.*"; profile = "lenovo-yoga-6-13ALC6"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*ideapad 15ach6.*"; profile = "lenovo-ideapad-15ach6"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*legion 5.*"; profile = "lenovo-legion-15ach6h"; state = "untested"; }
    { vendor = "lenovo"; pattern = ".*yoga pro 7 14iah10.*"; profile = "ojuny-lenovo-yoga-pro-7-14iah10"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface go.*"; profile = "microsoft-surface-go"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro 3.*"; profile = "microsoft-surface-pro-3"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro 9.*"; profile = "microsoft-surface-pro-9"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface pro.*"; profile = "microsoft-surface-pro-intel"; state = "untested"; }
    { vendor = "microsoft"; pattern = ".*surface laptop.*amd.*"; profile = "microsoft-surface-laptop-amd"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gf63.*"; profile = "msi-gf63"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gs60.*"; profile = "msi-gs60"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gl62.*"; profile = "msi-gl62"; state = "untested"; }
    { vendor = "msi"; pattern = ".*gl65.*"; profile = "msi-gl65-10SDR-492"; state = "untested"; }
    { vendor = "msi"; pattern = ".*prestige 15.*"; profile = "msi-prestige-15-a10sc"; state = "untested"; }
    { vendor = "msi"; pattern = ".*b550.*"; profile = "msi-b550-tomahawk"; state = "untested"; }
    { vendor = "panasonic"; pattern = ".*cf-lx3.*"; profile = "letsnote-cf-lx3"; state = "untested"; }
    { vendor = "panasonic"; pattern = ".*cf-lx4.*"; profile = "letsnote-cf-lx4"; state = "untested"; }
    { vendor = "purism"; pattern = ".*librem 13.*"; profile = "purism-librem-13v3"; state = "untested"; }
    { vendor = "purism"; pattern = ".*librem 15.*"; profile = "purism-librem-15v3"; state = "untested"; }
    { vendor = "razer"; pattern = ".*blade 14.*"; profile = "razer-blade-14-RZ09-0530"; state = "untested"; }
    { vendor = "samsung"; pattern = ".*np900x3c.*"; profile = "samsung-np900x3c"; state = "unsupported"; }
    { vendor = "slimbook"; pattern = ".*hero.*"; profile = "slimbook-hero-rpl-rtx"; state = "untested"; }
    { vendor = "starlabs"; pattern = ".*starlite.*"; profile = "starlabs-starlite-i5"; state = "untested"; }
    { vendor = "system76"; pattern = ".*gaze.*"; profile = "system76-gaze18"; state = "untested"; }
    { vendor = "system76"; pattern = ".*galago.*"; profile = "system76-galp5-1650"; state = "untested"; }
    { vendor = "system76"; pattern = ".*darter.*"; profile = "system76-darp6"; state = "untested"; }
    { vendor = "system76"; pattern = ".*thelio.*"; profile = "system76-thelio-mega"; state = "untested"; }
    { vendor = "system76"; pattern = ".*"; profile = "system76"; state = "untested"; }
    { vendor = "toshiba"; pattern = ".*satellite.*"; profile = "toshiba-swanky"; state = "unsupported"; }
    { vendor = "tuxedo"; pattern = ".*aura 15.*"; profile = "tuxedo-aura-15-gen1"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 9.*intel.*"; profile = "tuxedo-infinitybook-pro14-gen9-intel"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 9.*amd.*"; profile = "tuxedo-infinitybook-pro14-gen9-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*14.*gen 10.*amd.*"; profile = "tuxedo-infinitybook-pro14-gen10-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*infinitybook.*15.*gen 10.*amd.*"; profile = "tuxedo-infinitybook-pro15-gen10-amd"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*pulse 14.*"; profile = "tuxedo-pulse-14-gen3"; state = "untested"; }
    { vendor = "tuxedo"; pattern = ".*pulse 15.*"; profile = "tuxedo-pulse-15-gen2"; state = "untested"; }
    { vendor = "xiaomi"; pattern = ".*redmibook 15.*"; profile = "xiaomi-redmibook-15-pro-2021"; state = "untested"; }
    { vendor = "xiaomi"; pattern = ".*redmibook 16.*"; profile = "xiaomi-redmibook-16-pro-2024"; state = "untested"; }
  ];

  # Profiles whose nixos-hardware module owns GPU settings. A variant is imported
  # instead of the base profile when the layout detected from the facter report
  # matches. The primary GPU decision logic lives on the hardware profile page.
  gpuProfiles = {
    "asus-ally-rc71l" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "asus-flow-gv302x-amdgpu" = { owns = true; variants = [ { layout = "amd"; } { layout = "hybrid-amd-nvidia"; profile = "asus-flow-gv302x-nvidia"; } ]; };
    "asus-flow-gz301vu" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "asus-proart-px13" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "asus-proart-px13-hn7306eac" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "asus-rog-gl552vw" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "asus-rog-strix-g513im" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-rog-strix-g533q" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-rog-strix-g533zw" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "asus-rog-strix-g713ie" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-rog-strix-g733qs" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-zephyrus-ga401" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-zephyrus-ga401iv" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-zephyrus-ga402" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "asus-zephyrus-ga402x-amdgpu" = { owns = true; variants = [ { layout = "amd"; } { layout = "hybrid-amd-nvidia"; profile = "asus-zephyrus-ga402x-nvidia"; } ]; };
    "asus-zephyrus-ga502" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-zephyrus-ga503" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "asus-zephyrus-gu603h" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "asus-zephyrus-gu605cw" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "asus-zephyrus-gu605my" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } ]; };
    "dell-xps-15-7590" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-7590-nvidia"; } ]; };
    "dell-xps-15-9500" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-9500-nvidia"; } ]; };
    "dell-xps-15-9510" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-9510-nvidia"; } ]; };
    "dell-xps-15-9520" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-9520-nvidia"; } ]; };
    "dell-xps-15-9530" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-9530-nvidia"; } ]; };
    "dell-xps-15-9550" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-15-9550-nvidia"; } ]; };
    "dell-xps-15-9560-nvidia" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } { layout = "intel"; profile = "dell-xps-15-9560-intel"; } ]; };
    "dell-xps-15-9570-nvidia" = { owns = true; variants = [ { layout = "hybrid-intel-nvidia"; } { layout = "intel"; profile = "dell-xps-15-9570-intel"; } ]; };
    "dell-xps-17-9700-intel" = { owns = true; variants = [ { layout = "intel"; } { layout = "hybrid-intel-nvidia"; profile = "dell-xps-17-9700-nvidia"; } ]; };
    "dell-xps-17-9710-intel" = { owns = true; variants = [ { layout = "intel"; } ]; };
    "framework-13-7040-amd" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "framework-16-7040-amd" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "framework-16-amd-ai-300-series" = { owns = true; variants = [ { layout = "amd"; } { layout = "hybrid-amd-nvidia"; profile = "framework-16-amd-ai-300-series-nvidia"; } ]; };
    "framework-desktop-amd-ai-max-300-series" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "framework-amd-ai-300-series" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "hp-elitebook-845g7" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "hp-elitebook-845g8" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "hp-elitebook-845g9" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "lenovo-ideapad-15ach6" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "lenovo-legion-15ach6h" = { owns = true; variants = [ { layout = "hybrid-amd-nvidia"; } ]; };
    "lenovo-yoga-6-13ALC6" = { owns = true; variants = [ { layout = "amd"; } ]; };
    "lenovo-yoga-7-14ARH7-amdgpu" = { owns = true; variants = [ { layout = "amd"; } { layout = "hybrid-amd-nvidia"; profile = "lenovo-yoga-7-14ARH7-nvidia"; } ]; };
  };

  vendorAliases = [
    { vendor = "apple"; pattern = ".*apple.*"; }
    { vendor = "asus"; pattern = ".*asus.*"; }
    { vendor = "asus"; pattern = ".*asustek.*"; }
    { vendor = "chuwi"; pattern = ".*chuwi.*"; }
    { vendor = "dell"; pattern = ".*dell.*"; }
    { vendor = "framework"; pattern = ".*framework.*"; }
    { vendor = "gigabyte"; pattern = ".*gigabyte.*"; }
    { vendor = "google"; pattern = ".*google.*"; }
    { vendor = "gpd"; pattern = ".*gpd.*"; }
    { vendor = "hp"; pattern = ".*hewlett.*packard.*"; }
    { vendor = "hp"; pattern = ".*hp.*"; }
    { vendor = "hp"; pattern = ".*omen.*"; }
    { vendor = "huawei"; pattern = ".*huawei.*"; }
    { vendor = "intel"; pattern = ".*intel.*"; }
    { vendor = "lenovo"; pattern = ".*lenovo.*"; }
    { vendor = "microsoft"; pattern = ".*microsoft.*"; }
    { vendor = "msi"; pattern = ".*micro.star.*"; }
    { vendor = "msi"; pattern = ".*msi.*"; }
    { vendor = "panasonic"; pattern = ".*panasonic.*"; }
    { vendor = "purism"; pattern = ".*purism.*"; }
    { vendor = "razer"; pattern = ".*razer.*"; }
    { vendor = "samsung"; pattern = ".*samsung.*"; }
    { vendor = "slimbook"; pattern = ".*slimbook.*"; }
    { vendor = "starlabs"; pattern = ".*star.?labs.*"; }
    { vendor = "system76"; pattern = ".*system76.*"; }
    { vendor = "toshiba"; pattern = ".*toshiba.*"; }
    { vendor = "toshiba"; pattern = ".*dynabook.*"; }
    { vendor = "tuxedo"; pattern = ".*tuxedo.*"; }
    { vendor = "xiaomi"; pattern = ".*xiaomi.*"; }
  ];

  detectVendor =
    manufacturer:
    let
      alias = lib.findFirst
        (entry: builtins.match entry.pattern (lib.toLower manufacturer) != null)
        null
        vendorAliases;
    in
    if alias == null then "unknown" else alias.vendor;

  toBusId =
    sysfs:
    let
      parts = lib.splitString ":" sysfs;
      bus = lib.elemAt parts 1;
      devfn = lib.splitString "." (lib.elemAt parts 2);
      device = lib.elemAt devfn 0;
      function = lib.elemAt devfn 1;
      hex = value: toString (lib.fromHexString value);
    in
    "PCI:${hex bus}:${hex device}:${hex function}";

  cardVendor = card: lib.toLower ((card.vendor or { }).name or "");
  cardHex = card: (card.vendor or { }).hex or "";

  isIntel = card: lib.hasInfix "intel" (cardVendor card) || cardHex card == "8086";
  isAmd = card:
    lib.elem (cardHex card) [ "1002" "1022" ]
    || lib.hasInfix "advanced micro devices" (cardVendor card)
    || lib.hasInfix "ati " (cardVendor card)
    || cardVendor card == "ati";
  isNvidia = card: lib.hasInfix "nvidia" (cardVendor card) || cardHex card == "10de";

  first = list: if list == [ ] then null else lib.head list;

  busOf =
    card:
    let
      sysfs = card.sysfs_bus_id or "";
    in
    if sysfs == "" then null else toBusId sysfs;

  busOrDefault =
    list: default:
    let
      card = first list;
      bus = if card == null then null else busOf card;
    in
    if bus == null then default else bus;

  detectGpu =
    report:
    let
      hardware = report.hardware or { };
      cards = hardware.graphics_card or [ ];
      intel = lib.filter isIntel cards;
      amd = lib.filter isAmd cards;
      nvidia = lib.filter isNvidia cards;
      hasIntel = intel != [ ];
      hasAmd = amd != [ ];
      hasNvidia = nvidia != [ ];
      layout =
        if !hasIntel && !hasAmd && !hasNvidia then
          "unknown"
        else if hasIntel && hasNvidia && !hasAmd then
          "hybrid-intel-nvidia"
        else if hasAmd && hasNvidia && !hasIntel then
          "hybrid-amd-nvidia"
        else if hasIntel && hasAmd && !hasNvidia then
          "hybrid-intel-amd"
        else if hasIntel && !hasAmd && !hasNvidia then
          "intel"
        else if hasAmd && !hasIntel && !hasNvidia then
          "amd"
        else if hasNvidia && !hasIntel && !hasAmd then
          "nvidia"
        else
          "unknown";
      busIds = {
        intel = if hasIntel then busOrDefault intel "PCI:0:2:0" else "PCI:0:2:0";
        amd = if hasAmd then busOrDefault amd "PCI:5:0:0" else "PCI:5:0:0";
        nvidia = if hasNvidia then busOrDefault nvidia "PCI:1:0:0" else "PCI:1:0:0";
        discrete =
          if lib.length amd > 1 then
            busOrDefault (lib.tail amd) "PCI:5:0:0"
          else if lib.length intel > 1 then
            busOrDefault (lib.tail intel) "PCI:5:0:0"
          else if lib.length nvidia > 1 then
            busOrDefault (lib.tail nvidia) "PCI:5:0:0"
          else
            "PCI:5:0:0";
      };
    in
    {
      inherit layout busIds;
      source = if builtins.hasAttr "graphics_card" hardware then "facter" else "unknown";
    };

  resolveGpuProfile =
    baseProfile: gpu:
    let
      meta = gpuProfiles.${baseProfile} or null;
      variants = if meta == null then [ ] else meta.variants;
      matching = lib.findFirst (variant: variant.layout == gpu.layout) null variants;
      chosen = if matching != null then matching else (if variants == [ ] then null else lib.head variants);
    in
    {
      profile = if chosen != null && chosen ? profile then chosen.profile else baseProfile;
      managed = if meta == null then false else (meta.owns or false);
      layout = if chosen != null then chosen.layout else gpu.layout;
      inherit (gpu) busIds source;
    };

  rawDetect =
    report:
    let
      smbios = report.smbios.system or { };
      manufacturer = smbios.manufacturer or "";
      product = smbios.product or "";
      version = smbios.version or "";
      model =
        let
          name = lib.concatStringsSep " " (lib.filter (part: part != "") [ manufacturer product ]);
        in
        if name == "" then "unknown" else name;
      vendor = detectVendor manufacturer;
      matches =
        pattern:
        builtins.match pattern (lib.toLower product) != null
        || builtins.match pattern (lib.toLower version) != null;
      match = lib.findFirst
        (row: row.vendor == vendor && matches row.pattern)
        null
        hardwareProfiles;
    in
    if match == null then
      {
        inherit model vendor;
        baseProfile = "unmatched";
        profile = "unmatched";
        state = "unmatched";
      }
    else
      {
        inherit model vendor;
        baseProfile = match.profile;
        inherit (match) profile state;
      };

  detect =
    report:
    let
      base = rawDetect report;
      gpu = detectGpu report;
      resolved = resolveGpuProfile base.baseProfile gpu;
    in
    base
    // {
      profile = resolved.profile;
      gpu = {
        inherit (resolved) layout managed busIds source;
      };
    };

  gpuProfileBase = lib.listToAttrs (
    lib.concatMap
      (
        base:
        map
          (variant: { name = variant.profile; value = base; })
          (lib.filter (variant: variant ? profile) (gpuProfiles.${base}.variants or [ ]))
      )
      (lib.attrNames gpuProfiles)
  );

  facterPath = ../07-system/facter.json;
  detection =
    if builtins.pathExists facterPath then
      detect (builtins.fromJSON (builtins.readFile facterPath))
    else
      {
        model = "unknown";
        vendor = "unknown";
        baseProfile = "unmatched";
        profile = "unmatched";
        state = "unmatched";
        gpu = {
          layout = "unknown";
          managed = false;
          source = "unknown";
          busIds = {
            intel = "PCI:0:2:0";
            amd = "PCI:5:0:0";
            nvidia = "PCI:1:0:0";
            discrete = "PCI:5:0:0";
          };
        };
      };
in
{
  flake.lib.hardware-profile = detect;
  flake.lib.hardware-detection = detection;
  flake.lib.hardware-gpu-profiles = gpuProfiles;
  flake.lib.hardware-gpu-profile-base = gpuProfileBase;
  flake.lib.hardware-gpu-detection = detection.gpu;

  flake.modules.nixos.system-hardware-profile =
    { lib, ... }:
    {
      options.ojuny.hardware.detectedModel = lib.mkOption {
        type = lib.types.str;
        description = "SMBIOS manufacturer and product from the generated nixos-facter report.";
      };

      options.ojuny.hardware.detectedProfile = lib.mkOption {
        type = lib.types.str;
        description = "nixos-hardware profile selected for the detected machine, or unmatched.";
      };

      options.ojuny.hardware.detectedState = lib.mkOption {
        type = lib.types.str;
        description = "Coverage state for the detected machine: tested, untested, unsupported or unmatched.";
      };

      config = {
        ojuny.hardware.detectedModel = detection.model;
        ojuny.hardware.detectedProfile = detection.profile;
        ojuny.hardware.detectedState = detection.state;
      };
    };
}
