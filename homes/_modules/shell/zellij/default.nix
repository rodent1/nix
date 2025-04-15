{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.shell.zellij;
in
{
  options.modules.shell.zellij = {
    enable = lib.mkEnableOption "zellij";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zellij.enable = true;

      fish.interactiveShellInit = ''
        set -gx ZELLIJ_AUTO_ATTACH true
        set -gx ZELLIJ_AUTO_EXIT false

        if not string match -q "vscode" $TERM_PROGRAM
          if test -z $ZELLIJ
             and test -z $TMUX
            ${lib.getExe config.programs.zellij.package}
          end
        end
      '';
    };

    xdg.configFile.zellij.source = ./config;
    
  };
}
