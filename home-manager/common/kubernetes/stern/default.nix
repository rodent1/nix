{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.stern
  ];
}
