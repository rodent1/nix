{
  pkgs,
  ...
}:
{
  faugus-launcher = pkgs.callPackage ./faugus-launcher.nix { };
  wagoapp = pkgs.callPackage ./wagoapp.nix { };
}
