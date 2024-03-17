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
      functions = {
        k = {
          description = "kubectl shorthand";
          wraps = "kubectl";
          body = builtins.readFile ./functions/k.fish;
        };
      };
    };
  };

  home-manager.users.stianrs.home.packages = with pkgs-unstable; [
    fluxcd # flux CLI
    kubecolor # colorize kubectl output # TODO: replace with https://github.com/hidetatz/kubecolor
    kubectl # kubernetes CLI
    kubernetes-helm # helm CLI
    kustomize # kustomize CLI for sadists
    talosctl # talos CLI
    restic # restic CLI
  ];
}
