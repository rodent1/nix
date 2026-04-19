{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        # Hyprland configuration options go here
      '';
    };
  };
}
