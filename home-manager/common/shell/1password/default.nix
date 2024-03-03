{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs._1password
  ];
}
