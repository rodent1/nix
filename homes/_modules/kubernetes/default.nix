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
        helmfile
        kubeconform
        kubecolor
        kubernetes-helm
        kustomize
        minijinja
        minio-client
        stern

        # Kubectl plugins
        kubectl-cnpg
        kubectl-klock
        kubectl-node-shell
        kubectl-rook-ceph
      ])
      ++ (with pkgs.unstable; [
        kubectl
        talosctl
      ]);

    programs = {
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
