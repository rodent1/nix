{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # VSCode Fix
    ./../../editor/vscode-server
    # Shell
    ./../../shell/atuin/default.nix
    ./../../shell/bat/default.nix
    ./../../shell/eza/default.nix
    ./../../shell/fish/default.nix
    ./../../shell/git/default.nix
    ./../../shell/starship/default.nix

  ];

  home = {
    username = lib.mkDefault "stianrs";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
  };

  home.packages = with pkgs; [
    fluxcd # flux CLI
    go-task # task runner
    k9s # kubernetes viewer tool
    ktop # kubernetes top
    kubectl # kubernetes CLI
    kubecolor # colorize kubectl output
    kubernetes-helm # helm CLI
    kustomize # kustomize CLI for sadists
    talosctl # talos CLI
  ];
}
