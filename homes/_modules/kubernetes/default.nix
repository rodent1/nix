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
        helmfile
        kubeconform
        kubecolor
        kubecolor-catppuccin
        kubernetes-helm
        minijinja
        minio-client
        stern
        talhelper
        talosctl
      ])
      ++ (with pkgs.unstable; [ kubectl ]);

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
