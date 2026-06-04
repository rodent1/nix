{ pkgs, ... }:
{
  imports = [
    ./monitor.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./rules.nix
    ./wayle.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.nvidia
    mangohud
    unstable.rusty-path-of-building
    wagoapp
  ];
}
