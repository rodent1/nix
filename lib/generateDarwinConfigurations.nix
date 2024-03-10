{
  self,
  home-manager,
  nix-darwin,
  nixpkgs,
  nix-ld-rs,
  sops-nix,
  vscode-server,
  ...
}:
let
  inherit (nixpkgs) lib;
  genConfiguration = hostname: { hostPlatform, type, ... }:
    nix-darwin.lib.darwinSystem {
      system = hostPlatform;

      modules = [
        {
          _module.args = {
            system = hostPlatform;
            myPackages = self.packages.${hostPlatform};
            pkgs-unstable = self.pkgs-unstable.${hostPlatform};
            myLib = self.lib;
          };
          nixpkgs.pkgs = self.pkgs.${hostPlatform};
        }

        home-manager.darwinModules.home-manager
        # Load the modules
        ../modules/common
        ../modules/darwin
        # Host specific configuration
        ../hosts/${hostname}/configuration.nix
      ];
      specialArgs = {
        hostType = type;
        hostName = hostname;
        inherit
          home-manager
          nix-ld-rs
          sops-nix
          vscode-server;
      };
    };
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "darwin") self.hosts)
