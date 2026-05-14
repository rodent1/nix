{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.environments.hyprland;
  waybarCfg = cfg.waybar;
in
{
  options.modules.desktop.environments.hyprland.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Waybar configuration for Hyprland";
    };
  };

  config = lib.mkIf (config.modules.desktop.enable && cfg.enable && waybarCfg.enable) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    # Enable Catppuccin theming for Waybar
    catppuccin.waybar = {
      enable = true;
      mode = "createLink";
    };
  };
}
