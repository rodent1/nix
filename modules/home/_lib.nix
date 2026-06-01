{
  inputs,
  self,
  withSystem,
}:
let
  lib = inputs.nixpkgs.lib;

  sharedModules = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.opnix.homeManagerModules.default
  ];

  mkExtraSpecialArgs =
    {
      hostname,
      system ? "x86_64-linux",
      isWSL ? false,
    }:
    {
      inherit
        inputs
        hostname
        system
        isWSL
        ;
      availableHomeModules = self.homeModules;
      availableNixosModules = self.nixosModules;
    };

  mkHomeConfiguration =
    {
      hostname,
      system ? "x86_64-linux",
      isWSL ? false,
    }:
    withSystem system (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkExtraSpecialArgs {
          inherit hostname system isWSL;
        };
        modules = sharedModules ++ [ self.homeModules.stianrs ];
      }
    );
in
{
  inherit sharedModules mkExtraSpecialArgs mkHomeConfiguration;
}
