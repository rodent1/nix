{pkgs, lib, config, ... }:
{

  environment.systemPackages = [
    pkgs.btop
  ];

  programs.fish = {
    shellAliases = {
      top = "btop";
    };
  };
}
