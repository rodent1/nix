{
  rodent.packageRecipes.flate = ./_recipes/flate.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.flate = pkgs.flate;
    };
}
