{ pkgs, ... }:
{
  imports = [
    ./monitor.nix
    ./rules.nix
    ./wayle.nix
  ];

  home.packages = with pkgs; [
    mangohud
    unstable.rusty-path-of-building
    wagoapp
  ];
}
