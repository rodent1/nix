{
  config,
  inputs,
  lib,
  ...
}:
let
  additions =
    final: prev: lib.mapAttrs (_: recipe: final.callPackage recipe { }) config.rodent.packageRecipes;
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          additions
          config.rodent.overlays.aliases
          config.rodent.overlays.unstable
        ];
        config.allowUnfree = true;
      };
    };
}
