{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        wagoapp = pkgs.callPackage ../../pkgs/wagoapp.nix { };
      };
    };
}
