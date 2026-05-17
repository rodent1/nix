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

    programs.noctalia-shell.settings = {
      general = {
        lockScreenMonitors = [ "DP-2" ];
      };

      notifications = {
        monitors = [ "DP-2" ];
      };

      osd = {
        monitors = [ "DP-2" ];
      };
    };

    home.packages = with pkgs; [
      faugus-launcher
      mangohud
      unstable.rusty-path-of-building
      wagoapp
    ];

    home.file.".face".source = ../assets/profile.jpg;
  };
}
