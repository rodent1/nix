{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    '';
  };
}
