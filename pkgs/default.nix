{
  pkgs,
  ...
}:
{
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
  wails3 = pkgs.callPackage ./wails.nix { };
}
