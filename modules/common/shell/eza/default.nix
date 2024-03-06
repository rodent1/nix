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
      };

      fish = mkIf (cfg.enableFishIntegration) ({
        shellAliases = lib.mkDefault ({
          ld = "eza -lD";
          lf = "eza -lF --color=always | grep -v /";
          lh = "eza -dl .* --group-directories-first";
          ll = "eza -al --group-directories-first";
          ls = "eza -alF --color=always --sort=size | grep -v /";
          lt = "eza -al --sort=modified";
        });
      });
    });
  };
}
