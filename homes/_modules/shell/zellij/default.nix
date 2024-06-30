{ config, lib, ... }:
let
  cfg = config.modules.shell.zellij;
in
{
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
        if not set -q TERM_PROGRAM; or not string match -q "vscode" $TERM_PROGRAM
          if not set -q ZELLIJ
              if test "$ZELLIJ_AUTO_ATTACH" = "true"
                  if not set -q ZELLIJ_AUTO_ATTACH_SESSION_NAME
                      zellij attach -c
                  else
                      zellij attach -c $ZELLIJ_AUTO_ATTACH_SESSION_NAME
                  end
              else
                  zellij
              end

              if test "$ZELLIJ_AUTO_EXIT" = "true"
                  kill $fish_pid
              end
          end
        end
      '';

      home.sessionVariables = {
        ZELLIJ_AUTO_ATTACH = "true";
        ZELLIJ_AUTO_ATTACH_SESSION_NAME = "main";
      };
    })
  ];
}
