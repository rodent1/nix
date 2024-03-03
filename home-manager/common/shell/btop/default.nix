{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.btop
  ];

  programs.fish = {
    shellAliases = {
      top = "btop";
    };
  };
}
