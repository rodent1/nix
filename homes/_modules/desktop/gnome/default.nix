{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.environments.gnome;
in
{
  options.modules.desktop.environments.gnome.enable =
    lib.mkEnableOption "GNOME desktop user defaults";

  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    dconf.enable = true;

    home.packages = with pkgs; [
      eog
      evince
      file-roller
      gnome-calculator
      gnome-text-editor
      nautilus
      showtime
    ];
  };
}
