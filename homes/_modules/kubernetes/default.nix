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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Kubernetes tools and utilities.";
    };
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
