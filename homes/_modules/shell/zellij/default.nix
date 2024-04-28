{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.zellij;
  zellijCmd = lib.getExe pkgs.zellij;
in {
  options.modules.shell.zellij = {
    enable = lib.mkEnableOption "zellij";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.zellij = {
        enable = true;
        settings = {
          theme = "catppuccin-macchiato";
        };
      };

      programs.fish.interactiveShellInit = ''
        # do not run if inside VSCode terminal
        if not set -q TERM_PROGRAM; or not string match -q "vscode" $TERM_PROGRAM
          eval (${zellijCmd} setup --generate-auto-start fish | string collect)
        end
      '';
    })
  ];
}
