{ pkgs, ... }:
{
  config = {
    modules = {
      desktop = {
        enable = true;
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
    };

    home.packages = with pkgs; [
      mangohud
      unstable.rusty-path-of-building
      wagoapp
    ];

    wayland.windowManager.hyprland = {
      extraConfig = ''
        monitor = DP-1, 2560x1440@143.91Hz, 2560x-1800, 1, cm, srgb
        monitor = DP-2, 2560x1440@165.07Hz, 2560x-350, 1, cm, srgb
        monitor = DP-3, 1920x1080@143.98Hz, 5130x-580, 1, transform, 3, cm, srgb
      '';
    };

    home.file.".face".source = ../assets/profile.jpg;
  };
}
