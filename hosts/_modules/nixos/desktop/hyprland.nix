{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.environments.hyprland;
in
{
  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    programs.hyprland = {
      enable = true;
      inherit (cfg) package;
    };
  };
}
