{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.ssh;
  onePassPath = "~/.1password/agent.sock";
in {
  options.modules.users.${username}.shell.ssh = {
    enable = mkEnableOption "${username} ssh";

    config = mkOption {
      type = with types; attrsOf (oneOf [ str (listOf str) bool ]);
      default = {};
    };
  };

  config = {
    home-manager.users.${username}.programs = mkIf (cfg.enable) ({
      ssh = {
        enable = true;
        extraConfig = ''
          Host *
              IdentitiesOnly=yes
              IdentityAgent ${onePassPath}
        '';
      };
    });
  };
}
