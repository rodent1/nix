{
  config,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
  hostConfig = ./hosts + "/${hostname}.nix";
in
{
  imports = lib.optional (builtins.pathExists hostConfig) hostConfig;

  options.modules.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland compositor configuration";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional wayland.windowManager.hyprland.settings merged per host";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional raw Hyprland config merged per host";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      inherit (cfg) settings;
      inherit (cfg) extraConfig;
    };
  };
}
