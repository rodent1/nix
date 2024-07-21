{ lib, ... }:
{
  imports = [
    ./kubecm
    ./kubecolor
    ./kubectl
    ./stern
    ./talhelper
    ./utilities
  ];

  options.modules.kubernetes = {
    enable = lib.mkEnableOption "kubernetes";
  };
}
