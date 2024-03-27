{ lib, ... }: {
  imports = [
    ./flux
    ./helmfile
    ./k9s
    ./krew
    ./kubecm
    ./kubecolor
    ./kubeconform
    ./kubectl
    ./stern
    ./talosctl
  ];

  options.modules.kubernetes = { enable = lib.mkEnableOption "kubernetes"; };
}
