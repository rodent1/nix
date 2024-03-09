{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.gh;
in {
   options.modules.users.${username}.shell.gh = {
    enable = mkEnableOption "${username} gh";

    config = mkOption {
      type = with types; attrsOf (oneOf [ str (listOf str) bool ]);
      default = {};
    };
  };

  config = {
    home-manager.users.${username}.programs = mkIf (cfg.enable) ({
      gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    });
  };
}
