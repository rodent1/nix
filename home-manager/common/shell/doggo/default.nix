{ config, ... }:

{
  programs.doggo = {
    enable = true;
    package = pkgs.doggo;
  };

  programs.fish.shellAliases = {
    dig = "dig";
  };
}
