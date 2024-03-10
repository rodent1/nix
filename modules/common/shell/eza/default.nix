{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.eza;
in {
   options.modules.users.${username}.shell.eza = {
    enable = mkEnableOption "${username} eza";

    enableFishIntegration = mkEnableOption "${username} eza fish integration";

    config = mkOption {
      type = with types; attrsOf (oneOf [ str (listOf str) bool ]);
      default = {};
    };
  };

  config = {
    home-manager.users.${username}.programs = mkIf (cfg.enable) ({
      eza = {
        enable = true;
        icons = true;
      };

      fish = mkIf (cfg.enableFishIntegration) ({
        shellAliases = {
          ls = "eza";
          ll = "eza -al --group-directories-first";
          la = "eza -la";
          ld = "eza -lD";
          lh = "eza -dl .* --group-directories-first";
          lt = "eza -al --sort=modified";
        };
      });
    });
  };
}
