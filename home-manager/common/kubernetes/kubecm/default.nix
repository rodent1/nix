{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.kubecm
  ];

  programs.fish.interactiveShellInit = ''
      kubecm completion fish | source
    '';

  programs.fish.shellAliases = { kc = "kubecm"; };
}
