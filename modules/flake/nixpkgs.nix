{
  config,
  inputs,
  lib,
  ...
}:
let
  additions =
    final: prev: lib.mapAttrs (_: recipe: final.callPackage recipe { }) config.internal.packageRecipes;
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          additions
          config.internal.overlays.aliases
          config.internal.overlays.unstable
        ];
        config.allowUnfree = true;
      };
    };
}
