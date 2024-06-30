{lib, ...}: {
  imports = [
    ./kubecm
    ./kubecolor
    ./kubectl
    ./talhelper
    ./utilities
  ];

  options.modules.kubernetes = {enable = lib.mkEnableOption "kubernetes";};
}
