{
  internal.packageRecipes.moonfin = ./_recipes/moonfin.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.moonfin = pkgs.moonfin;
    };
}
