{ username }: {lib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.eza;

  defaultConfig = import ./defaultConfig.nix;

in {
  options.modules.users.${username}.shell.eza = {
    enable = mkEnableOption "${username} eza";
    enableFishIntegration = mkEnableOption "${username} eza fish integration";
    config = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      settings = mkMerge [
        defaultConfig
        cfg.config
      ];
    };

    home-manager.users.${username}.programs.fish = mkIf (cfg.enableFishIntegration) ({
      shellAliases = {
        ld = "eza -lD";
        lf = "eza -lF --color=always | grep -v /";
        lh = "eza -dl .* --group-directories-first";
        ll = "eza -al --group-directories-first";
        ls = "eza -alF --color=always --sort=size | grep -v /";
        lt = "eza -al --sort=modified";
      };
    });

  };
}
