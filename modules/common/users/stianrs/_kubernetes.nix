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
      shellAliases = {
        k = "kubectl";
      };
      interactiveShellInit = ''
        flux completion fish | source
      '';
    };
  };
}
