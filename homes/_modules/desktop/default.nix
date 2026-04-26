{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.desktop;
in
{
  imports = [
    ./niri
  ];

  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop applications";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      firefox.enable = true;
      fuzzel.enable = true;
      swaylock.enable = true;
      vesktop.enable = true;

      ghostty = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          confirm-close-surface = false;
          link-url = true;
          maximize = true;
        };
      };

      vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
      };
    };
    services = {
      mako.enable = true; # notification daemon
      swayidle.enable = true; # idle management daemon
      polkit-gnome.enable = true; # polkit
    };

    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.monaspace
      swaybg
      xfce.thunar
    ];
  };
}
