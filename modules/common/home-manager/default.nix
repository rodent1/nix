{ username }: {lib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.home-manager;
in
{
  imports = [
    ( import ../editor/nvim {username=username;} )
    ( import ../editor/vscode-server {username=username;} )
    # Kubernetes
    ( import ../kubernetes/k9s {username=username;} )
    ( import ../kubernetes/krew {username=username;} )
    ( import ../kubernetes/kubecm {username=username;} )
    ( import ../kubernetes/stern {username=username;} )
    # Shell
    ( import ../shell/1password {username=username;} )
    ( import ../shell/atuin {username=username;} )
    ( import ../shell/bat {username=username;} )
    ( import ../shell/btop {username=username;} )
    ( import ../shell/direnv {username=username;} )
    ( import ../shell/doggo {username=username;} )
    ( import ../shell/eza {username=username;} )
    ( import ../shell/fish {username=username;} )
    ( import ../shell/git{username=username;} )
    ( import ../shell/minio-client {username=username;} )
    ( import ../shell/starship {username=username;} )
    ( import ../shell/tmux {username=username;} )
    # Sops
    ( import ../sops {username=username;} )
    # Misc
    ( import ../fonts/monaspace {username=username;} )
  ];

  options.modules.users.${username}.home-manager = {
    enable = mkEnableOption "${username} home-manager";
  };

  config = mkMerge [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }

    (mkIf (cfg.enable) {
      home-manager.users.${username} = {
        home = {
          stateVersion = "23.11";
        };

        programs = {
          home-manager.enable = true;
        };
      };
    })
  ];
}
