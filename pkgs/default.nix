{
  pkgs,
  ...
}:
{
  gh-tidy = pkgs.callPackage ./gh-tidy.nix { };
}
