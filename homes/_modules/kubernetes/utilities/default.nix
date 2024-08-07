{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      fluxcd
      helmfile
      krew
      kubeconform
      kubernetes-helm
      minio-client
      unstable.talosctl
    ];
  };
}
