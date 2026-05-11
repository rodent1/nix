{
  pkgs,
  ...
}:
{
  faugus-launcher = pkgs.callPackage ./faugus-launcher.nix { };
  hyprmod = pkgs.callPackage ./hyprmod.nix { };
  wagoapp = pkgs.callPackage ./wagoapp.nix { };
}
