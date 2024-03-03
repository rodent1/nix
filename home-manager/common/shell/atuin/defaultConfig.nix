{pkgs, pkgs-unstable, lib, config, ... }:
{
  programs.atuin = {
    enable = true;
    package = pkgs-unstable.atuin;

    flags = [
      "--disable-up-arrow"
    ];

    settings = import ./defaultConfig {};
  };
}
