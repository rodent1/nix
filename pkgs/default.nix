{
  pkgs,
  ...
}:
{
  flate = pkgs.callPackage ./flate.nix { };
  wagoapp = pkgs.callPackage ./wagoapp.nix { };
}
