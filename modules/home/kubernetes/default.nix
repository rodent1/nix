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
        home.packages = with pkgs; [
          flate
          fluxcd
          unstable.gum
          unstable.helmfile
          unstable.just
          unstable.kubectl
          krew
          kubecolor
          kubernetes-helm
          kustomize
          minijinja
          stern
          unstable.talosctl
        ];

        programs = {
          fish = {
            shellInit = ''
              fish_add_path --global --prepend $HOME/.krew/bin
            '';

            functions = {
              k = {
                wraps = "kubecolor";
                body = "kubecolor $argv";
              };

              kubectl = {
                wraps = "kubecolor";
                body = "kubecolor $argv";
              };
            };
          };
        };
      };
    };
}
