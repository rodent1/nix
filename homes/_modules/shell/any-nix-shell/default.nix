{ lib, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [ any-nix-shell ];

    programs.fish = {
      interactiveShellInit = "${lib.getExe pkgs.any-nix-shell} fish --info-right | source";
    };
  };
}
