{ config, lib, ... }:
let
  cfg = config.modules.shell.zellij;
  cmd = lib.getExe config.programs.zellij.package;
in
{
  options.modules.shell.zellij = {
    enable = lib.mkEnableOption "zellij";
  };

  config = lib.mkIf (cfg.enable) {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "catppuccin-macchiato";
      };
    };

    programs.fish.interactiveShellInit = ''
      if not string match -q "vscode" $TERM_PROGRAM
        set -gx ZELLIJ_AUTO_ATTACH true
        set -gx ZELLIJ_AUTO_EXIT false
        eval (${cmd} setup --generate-auto-start fish | string collect)
      end
    '';
  };
}
