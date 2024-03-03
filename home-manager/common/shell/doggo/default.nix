{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.doggo
  ];

  programs.fish = {
    shellAliases = {
      dig = "doggo";
    };
  };
}
