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
    ./../../editors/vscode-server
    # Editors
    ./../../editors/nvim
    # Kubernetes
    ./../../kubernetes/krew
    ./../../kubernetes/kubecm
    ./../../kubernetes/stern
    # Shell
    ./../../shell/1password
    ./../../shell/atuin
    ./../../shell/bat
    ./../../shell/btop
    ./../../shell/direnv
    ./../../shell/doggo
    ./../../shell/eza
    ./../../shell/fish
    ./../../shell/git
    ./../../shell/starship
    # Misc
    ./../../fonts/monaspace

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
    kubecolor # colorize kubectl output
    kubectl # kubernetes CLI
    kubernetes-helm # helm CLI
    kustomize # kustomize CLI for sadists
    talosctl # talos CLI
  ];
}
