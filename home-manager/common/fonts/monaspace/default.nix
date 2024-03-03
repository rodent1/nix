{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.monaspace
  ];
}
