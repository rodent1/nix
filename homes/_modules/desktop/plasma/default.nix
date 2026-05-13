{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.environments.plasma;
in
{
  options.modules.desktop.environments.plasma.enable = lib.mkEnableOption "KDE Plasma user defaults";

  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    home.packages = with pkgs.kdePackages; [
      ark
      dolphin
      gwenview
      kate
      kcalc
      okular
    ];
  };
}
