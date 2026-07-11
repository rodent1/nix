{
  rodent.packageRecipes.wagoapp = ./_recipes/wagoapp.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.wagoapp = pkgs.wagoapp;
    };
}
