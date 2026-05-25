{ pkgs, ... }:
{
  imports = [
    ./monitor.nix
    ./rules.nix
    ./wayle.nix
  ];

  home.packages = with pkgs; [
    nvtopPackages.nvidia
    mangohud
    unstable.heroic
    unstable.rusty-path-of-building
    wagoapp
  ];
}
