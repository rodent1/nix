{ pkgs, ... }:
{
  config = {
    modules = {
      desktop = {
        enable = true;
        niri = {
          enable = true;
          noctalia.enable = true;
        };
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
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
