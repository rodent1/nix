{
  internal.homeModules.default =
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
            flate
            fluxcd
            helmfile
            kubecolor
            kubernetes-helm
            kustomize
            minijinja
            minio-client
            stern

            # Kubectl plugins
            krew
            kubectl-cnpg
            kubectl-klock
            kubectl-kopiur
            kubectl-node-shell
            kubectl-rook-ceph
            kubectl-view-secret
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
    };
}
