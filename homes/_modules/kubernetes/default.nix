{lib, ...}: {
  imports = [
    ./flux
    ./helmfile
    ./helm
    ./k9s
    ./krew
    ./kubecm
    ./kubecolor
    ./kubeconform
    ./kubectl
    ./stern
    ./talhelper
    ./talosctl
  ];

  options.modules.kubernetes = {enable = lib.mkEnableOption "kubernetes";};
}
