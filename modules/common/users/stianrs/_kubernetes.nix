{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  modules.users.stianrs.kubernetes.k9s = {
    enable = true;
    package = pkgs-unstable.k9s;
    config = {
      k9s = {
        ui = {
          skin = "catppuccin-macchiato";
        };
      };
    };
  };
  modules.users.stianrs.kubernetes.krew.enable = true;
  modules.users.stianrs.kubernetes.kubecm = {
    enable = true;
    package = pkgs-unstable.kubecm;
  };
  modules.users.stianrs.kubernetes.stern.enable = true;

  modules.users.stianrs.shell.fish = {
    config.programs.fish = {
      interactiveShellInit = ''
        flux completion fish | source
        stern --completion fish | source
      '';
    };
  };

  home-manager.users.stianrs.home.packages = with pkgs-unstable; [
    fluxcd # flux CLI
    kubecolor # colorize kubectl output
    kubectl # kubernetes CLI
    kubernetes-helm # helm CLI
    kustomize # kustomize CLI for sadists
    talosctl # talos CLI
  ];

}
