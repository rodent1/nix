{
  inputs,
  self,
}:
let
  lib = inputs.nixpkgs.lib;
  homeLib = import ../home/_lib.nix {
    inherit inputs self;
    withSystem =
      system: f:
      f {
        pkgs = self.lib.mkPkgsWithSystem system;
        system = system;
      };
  };

  mkHost =
    {
      system ? "x86_64-linux",
      hostname,
      hostModule,
      isWSL ? false,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = self.lib.mkPkgsWithSystem system;
      modules = [
        {
          nixpkgs.hostPlatform = system;
          _module.args = {
            inherit inputs system;
          };
        }
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home-manager.nixosModules.home-manager
        inputs.opnix.nixosModules.default
        {
          home-manager = {
            sharedModules = homeLib.sharedModules;
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = homeLib.mkExtraSpecialArgs {
              inherit hostname system isWSL;
            };
            users.stianrs = self.homeModules.stianrs;
          };
        }
        self.nixosModules.common-legacy
        self.nixosModules.nixos-legacy
      ]
      ++ lib.optionals (!isWSL) [
        inputs.nix-index-database.nixosModules.nix-index
      ]
      ++ lib.optionals isWSL [
        inputs.nixos-wsl.nixosModules.default
        self.nixosModules.wsl-legacy
      ]
      ++ [ hostModule ];
      specialArgs = {
        inherit inputs hostname;
      };
    };
in
{
  mkNixosHost = args: mkHost (args // { isWSL = false; });
  mkWslHost = args: mkHost (args // { isWSL = true; });
}
