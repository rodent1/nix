{ ... }:
{
  flake.overlays.additions = final: _prev: {
    wagoapp = final.callPackage ../../pkgs/wagoapp.nix { };
  };
}
