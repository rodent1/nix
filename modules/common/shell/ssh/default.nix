{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.ssh;
  socket = "~/.ssh/agent.sock";
in {
  options.modules.users.${username}.shell.ssh = {
    enable = mkEnableOption "${username} ssh";

    config = mkOption {
      type = with types; attrsOf (oneOf [ str (listOf str) bool ]);
      default = {};
    };
  };

  config = mkIf (cfg.enable) ({
    home-manager.users.${username}.programs = {
      ssh = {
        enable = true;
        matchBlocks = {
          "*" = {
            extraOptions = {
              IdentityAgent = "${socket}";
            };
          };
          "udm" = {
            extraOptions = {
              User = "root";
              Hostname = "10.1.1.1";
            };
          };

          "tank" = {
            extraOptions = {
              Hostname = "10.1.1.15";
            };
          };
        };
      };
    };
  });
}
