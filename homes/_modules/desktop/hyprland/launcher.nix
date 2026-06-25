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
    programs.fuzzel = {
      enable = true;
    };

    catppuccin.fuzzel.enable = true;
  };
}
