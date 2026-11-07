/*
  The global EDITOR default is mkDefault, so any normal-priority definition
  wins. A per-editor defaultEditor switch writes EDITOR and VISUAL at normal
  priority and therefore overrides micro. With no switch on, micro stays.
  Turning on two switches is a configuration error, not a silent winner.
*/

{ lib, ... }:

let
  microColorscheme = colors:
    lib.concatStringsSep "\n" [
      ''color-link default "${colors.base05},${colors.base00}"''
      ''color-link comment "${colors.base03}"''
      ''color-link identifier "${colors.base08}"''
      ''color-link constant "${colors.base09}"''
      ''color-link constant.string "${colors.base0B}"''
      ''color-link constant.number "${colors.base09}"''
      ''color-link constant.bool "${colors.base09}"''
      ''color-link statement "${colors.base0E}"''
      ''color-link symbol "${colors.base0C}"''
      ''color-link symbol.operator "${colors.base0C}"''
      ''color-link symbol.brackets "${colors.base0C}"''
      ''color-link symbol.tag "${colors.base0D}"''
      ''color-link preproc "${colors.base0F}"''
      ''color-link type "${colors.base0A}"''
      ''color-link special "${colors.base0C}"''
      ''color-link underlined "underline ${colors.base0C}"''
      ''color-link error "bold ${colors.base08}"''
      ''color-link todo "bold ${colors.base0A}"''
      ''color-link hlsearch "${colors.base00},${colors.base0A}"''
      ''color-link statusline "${colors.base05},${colors.base02}"''
      ''color-link statusline.inactive "${colors.base04},${colors.base01}"''
      ''color-link tabbar "${colors.base05},${colors.base02}"''
      ''color-link tabbar.active "${colors.base05},${colors.base02}"''
      ''color-link indent-char "${colors.base03}"''
      ''color-link line-number "${colors.base04}"''
      ''color-link current-line-number "${colors.base05}"''
      ''color-link selection "${colors.base00},${colors.base02}"''
      ''color-link gutter "${colors.base04},${colors.base01}"''
      ''color-link gutter-info "${colors.base0C}"''
      ''color-link gutter-error "${colors.base08}"''
      ''color-link gutter-warning "${colors.base0A}"''
      ''color-link message "${colors.base05},${colors.base00}"''
      ''color-link error-message "${colors.base08},${colors.base00}"''
      ''color-link cursor-line "${colors.base01}"''
      ''color-link color-column "${colors.base01}"''
      ''color-link match-brace "${colors.base00},${colors.base0A}"''
      ''color-link scrollbar "${colors.base02},${colors.base00}"''
      ''color-link divider "${colors.base02}"''
      ''color-link diff-added "${colors.base0B}"''
      ''color-link diff-modified "${colors.base0A}"''
      ''color-link diff-deleted "${colors.base08}"''
      ''color-link tab-error "${colors.base08}"''
      ''color-link trailingws "${colors.base08}"''
    ]
    + "\n";
in
{

  flake.modules.homeManager.users-user-editor = { config, pkgs, ... }:
    let
      textMimeTypes = [
        "text/plain"
        "text/markdown"
        "text/x-markdown"
        "text/x-log"
        "application/x-zerosize"
        "application/json"
        "application/yaml"
        "application/x-yaml"
        "application/toml"
        "application/x-toml"
        "text/xml"
        "application/xml"
        "text/css"
        "text/x-shellscript"
        "application/x-shellscript"
        "text/x-sh"
        "text/x-zsh"
        "text/x-python"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "text/x-c++hdr"
        "text/x-java"
        "text/x-perl"
        "text/x-pascal"
        "text/x-diff"
        "text/x-sql"
        "text/x-php"
        "application/x-php"
        "application/x-httpd-php"
        "text/x-rst"
        "text/x-tex"
        "text/x-lua"
        "text/x-ruby"
        "text/x-nix"
        "text/javascript"
        "application/javascript"
        "application/x-javascript"
      ];
    in
    {
      xdg.enable = true;
      xdg.mimeApps.enable = true;
      xdg.mimeApps.defaultApplications = lib.genAttrs textMimeTypes (
        _: "ojuny-editor.desktop"
      );

      home.packages = [
        (pkgs.writeShellScriptBin "ojuny-editor" ''
          exec "''${EDITOR:-micro}" "$@"
        '')
      ];

      xdg.desktopEntries.ojuny-editor = {
        name = "Text Editor";
        genericName = "Text Editor";
        comment = "Edit text files in the terminal";
        exec = "ojuny-editor %f";
        icon = "accessories-text-editor";
        terminal = true;
        categories = [ "Utility" "TextEditor" ];
        mimeType = textMimeTypes;
      };

      xdg.configFile."xdg-terminals.list".text = "ghostty.desktop\n";

      programs.micro.enable = true;
      programs.micro.settings.colorscheme = "ojuny";

      # Stylix's micro target hard-codes the "simple" colorscheme; disable it so
      # the generated scheme is the only definition.
      stylix.targets.micro.enable = lib.mkForce false;

      xdg.configFile."micro/colorschemes/ojuny.micro".text =
        microColorscheme config.lib.stylix.colors.withHashtag;

      home.sessionVariables.EDITOR = lib.mkDefault "micro";
      home.sessionVariables.TERMINAL = "ghostty";

      systemd.user.sessionVariables = {
        EDITOR = config.home.sessionVariables.EDITOR;
        TERMINAL = "ghostty";
      };
    };

  flake.modules.nixos.users-user-editor = { config, ... }:
    let
      editorSwitches = [
        {
          option = "ojuny.patch.nixvim.defaultEditor";
          enabled = config.ojuny.patch.nixvim.defaultEditor or false;
        }
        {
          option = "ojuny.patch.emacs.defaultEditor";
          enabled = config.ojuny.patch.emacs.defaultEditor or false;
        }
        {
          option = "ojuny.patch.helix.defaultEditor";
          enabled = config.ojuny.patch.helix.defaultEditor or false;
        }
        {
          option = "ojuny.patch.zed.defaultEditor";
          enabled = config.ojuny.patch.zed.defaultEditor or false;
        }
      ];

      enabledEditors = map (entry: entry.option) (
        builtins.filter (entry: entry.enabled) editorSwitches
      );
    in
    {
      assertions = [
        {
          assertion = builtins.length enabledEditors <= 1;
          message =
            "Only one editor may own EDITOR, but these are enabled: "
            + lib.concatStringsSep ", " enabledEditors
            + ". Turn off all but one of ojuny.patch.nixvim.defaultEditor, "
            + "ojuny.patch.emacs.defaultEditor, ojuny.patch.helix.defaultEditor "
            + "and ojuny.patch.zed.defaultEditor.";
        }
      ];
    };

}
