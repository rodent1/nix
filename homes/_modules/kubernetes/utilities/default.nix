{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      fluxcd
      helmfile
      kubeconform
      kubernetes-helm
      minio-client
      unstable.talosctl
    ];
  };
}
