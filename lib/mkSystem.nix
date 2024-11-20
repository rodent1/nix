{ inputs, ... }:
let
  baseLib = import ./modules/basesystem.nix { inherit inputs; };
in
{
  mkNixosSystem =
    system: hostname:
    baseLib.mkBaseSystem {
      inherit system hostname;
      systemFunction = inputs.nixpkgs.lib.nixosSystem;
      modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        ../hosts/_modules/nixos
        ../hosts/${hostname}
      ];
    };

  mkWslSystem =
    system: hostname:
    baseLib.mkBaseSystem {
      inherit system hostname;
      systemFunction = inputs.nixpkgs.lib.nixosSystem;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-wsl.nixosModules.default
        ../hosts/_modules/nixos
        ../hosts/_modules/wsl
        ../hosts/${hostname}
      ];
    };

  mkDarwinSystem =
    system: hostname:
    baseLib.mkBaseSystem {
      inherit system hostname;
      systemFunction = inputs.nix-darwin.lib.darwinSystem;
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nixvim.nixDarwinModules.nixvim
        ../hosts/_modules/darwin
        ../hosts/${hostname}
      ];
    };
}
