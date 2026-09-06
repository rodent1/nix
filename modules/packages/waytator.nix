{
  internal.packageRecipes.waytator = ./_recipes/waytator.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.waytator = pkgs.waytator;
    };
}
