{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.kubernetes;
  catppuccinCfg = config.modules.themes.catppuccin;
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
        kubecolor-catppuccin
        kubernetes-helm
        kustomize
        minijinja
        minio-client
        stern
        talosctl
      ])
      ++ (with pkgs.unstable; [
        kubectl
        helmfile
      ]);

    home.sessionVariables = {
      KUBECOLOR_CONFIG = "${pkgs.kubecolor-catppuccin}/catppuccin-${catppuccinCfg.flavor}.yaml";
    };

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

      fish = {
        shellAliases = {
          kubectl = "kubecolor";
          k = "kubectl";
        };
      };
    };
  };
}
