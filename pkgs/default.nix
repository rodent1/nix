{
  pkgs,
  ...
}:
{
  wagoapp = pkgs.callPackage ./wagoapp.nix { };
}
