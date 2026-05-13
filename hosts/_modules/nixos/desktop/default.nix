{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
  envCfg = cfg.environments;
in
{
  imports = [
    ./base.nix
    ./gnome.nix
    ./hyprland.nix
    ./niri.nix
    ./plasma.nix
  ];

  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop system configuration";

    sessionManager = lib.mkOption {
      type = lib.types.enum [ "sddm" ];
      default = "sddm";
      description = "Display manager used for desktop sessions";
    };

    environments = {
      niri = {
        enable = lib.mkEnableOption "niri system integration";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.unstable.niri;
          description = "niri package to install and use";
        };
      };

      hyprland = {
        enable = lib.mkEnableOption "Hyprland system integration";

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.hyprland;
          description = "Hyprland package to install and use";
        };
      };

      gnome.enable = lib.mkEnableOption "GNOME desktop session";
      plasma.enable = lib.mkEnableOption "KDE Plasma desktop session";
    };
  };

  config = {
    assertions = [
      {
        assertion =
          (!cfg.enable)
          || lib.any (enabled: enabled) [
            envCfg.niri.enable
            envCfg.hyprland.enable
            envCfg.gnome.enable
            envCfg.plasma.enable
          ];
        message = "modules.desktop.enable requires at least one enabled desktop environment";
      }
    ];
  };
}
