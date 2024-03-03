{pkgs, lib, config, ... }:
{

  environment.systemPackages = [
    pkgs.doggo
  ];

  programs.fish = {
    shellAliases = {
      dig = "doggo";
    };
  };
}
