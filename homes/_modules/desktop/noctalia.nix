{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop.noctalia;
in
{
  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
    };

    programs.swaylock.enable = true;

    home.packages = with pkgs; [
      fuzzel
      swaybg
    ];
  };
}
