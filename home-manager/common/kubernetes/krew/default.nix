{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.krew
  ];

  programs.fish.interactiveShellInit = ''
      fish_add_path $HOME/.krew/bin
    '';
}
