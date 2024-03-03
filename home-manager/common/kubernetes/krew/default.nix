{ pkgs, lib, ... }:
with lib;
{
  home.packages = with pkgs; [
    pkgs.kubecm
  ];

  programs.fish = {
    interactiveShellInit = ''
      kubebcm completion fish | source
    '';
    shellAliases = { kc = "kubecm"; };
  };
}
