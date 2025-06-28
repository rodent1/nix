{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.kubernetes;
in
{
  options.modules.kubernetes = {
    enable = lib.mkEnableOption "kubernetes";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        fluxcd
        gum
        kubeconform
        kubecolor
        kubernetes-helm
        kustomize
        minijinja
        minio-client
        stern
      ])
      ++ (with pkgs.unstable; [
        kubectl
        helmfile
        talosctl
      ]);

    programs = {
      krewfile = {
        enable = true;
        krewPackage = pkgs.krew;
        plugins = [
          "browse-pvc"
          "cnpg"
          "klock"
          "resource-capacity"
          "node-shell"
          "rook-ceph"
        ];
      };

      fish.functions = {
        k = {
          wraps = "kubecolor";
          body = "kubecolor --force-colors=auto $argv";
        };

        kubectl = {
          wraps = "kubecolor";
          body = "kubecolor --force-colors=auto $argv";
        };
      };
    };
  };
}
