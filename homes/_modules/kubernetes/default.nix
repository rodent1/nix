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
        helmfile
        kubeconform
        kubecolor-catppuccin
        kubernetes-helm
        minio-client
        talhelper
        talosctl
      ])
      ++ (with pkgs.unstable; [
        kubecolor
        kubectl
        stern
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
          "node-shell"
          "rook-ceph"
        ];
      };

      fish = {
        functions = {
          k = {
            description = "kubectl shorthand";
            wraps = "kubectl";
            body = builtins.readFile ./functions/k.fish;
          };
        };

        shellAliases = {
          kc = "kubecm";
        };
      };
    };
  };
}
