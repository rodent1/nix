{
  pkgs,
  ...
}:
{
  faugus-launcher = pkgs.callPackage ./faugus-launcher.nix { };
}
