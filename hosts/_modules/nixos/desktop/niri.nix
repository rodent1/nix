{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.environments.niri;
in
{
  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    programs.niri = {
      enable = true;
      inherit (cfg) package;
    };

    environment.systemPackages = [ pkgs.xwayland-satellite ];
  };
}
