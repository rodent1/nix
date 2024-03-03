{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.kubecm
  ];

  programs = {
    fish.interactiveShellInit = ''
      ${getExe pkgs.kubecm} completion fish | source
    '';
    shellAliases = { kc = "kubecm"; };
  };
}
