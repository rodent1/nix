{
  lib,
  pkgs,
  pkgs-unstable,
  myPackages,
  ...
}:
{
  home-manager.users.stianrs.home.packages = [
    pkgs.envsubst
    pkgs.go-task
    pkgs.nvd
  ];
}
