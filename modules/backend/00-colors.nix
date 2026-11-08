{ self, inputs, ... }:
let
  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) else str;

  mkNamedColors = stylixColors:
    let
      h = builtins.mapAttrs (_: v: stripHash v) {
        inherit (stylixColors)
          base00 base01 base02 base03 base04 base05 base06 base07
          base08 base09 base0A base0B base0C base0D base0E base0F;
      };
      mkColor = hex: {
        hex = "#" + hex;
        rgba = alpha: "0x" + hex + alpha;
      };
    in {
      defaultBackground   = mkColor h.base00;
      lighterBackground   = mkColor h.base01;
      selectionBackground = mkColor h.base02;
      comments            = mkColor h.base03;
      darkForeground      = mkColor h.base04;
      defaultForeground   = mkColor h.base05;
      lightForeground     = mkColor h.base06;
      lightBackground     = mkColor h.base07;
      variables           = mkColor h.base08;
      integers            = mkColor h.base09;
      classes             = mkColor h.base0A;
      strings             = mkColor h.base0B;
      support             = mkColor h.base0C;
      functions           = mkColor h.base0D;
      keywords            = mkColor h.base0E;
      deprecated          = mkColor h.base0F;
    };
in {
  flake.colors = mkNamedColors;

  flake.modules.homeManager.stylix-colors = { config, lib, ... }:
  let
    namedColors = mkNamedColors config.lib.stylix.colors;
    colorFile = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: val: "${name}|${val.hex}") namedColors
    );
  in {
    home.file.".stylix-colors".text = colorFile + "\n";
  };
}
