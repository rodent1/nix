{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.vscode-server-fix;
in {
   options.modules.users.${username}.shell.vscode-server-fix = {
    enable = mkEnableOption "${username} vscode-server-fix";
  };

  config = mkIf (cfg.enable) ({
    home-manager.users.${username}.home.file = {
      vscode-server-fix = {
        target = ".vscode-server/server-env-setup";
        text = ''
          # Make sure that basic commands are available
          PATH=$PATH:/run/current-system/sw/bin/
        '';
      };
    };
  });
}
