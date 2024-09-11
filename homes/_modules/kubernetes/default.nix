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
        helmfile
        krew
        kubecm
        kubeconform
        kubernetes-helm
        kubecolor
        kubectl-rook-ceph
        minio-client
        talhelper
      ])
      ++ (with pkgs.unstable; [
        kubectl
        kubectl-cnpg
        kubectl-node-shell
        kubectl-view-secret
        stern
        talosctl
      ]);

    programs.fish = {
      interactiveShellInit = ''
        fish_add_path $HOME/.krew/bin
        ${lib.getExe pkgs.unstable.kubecm} completion fish | source
      '';

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
}
