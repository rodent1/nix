{
  pkgs,
  ...
}:
{
  flate = pkgs.callPackage ./flate.nix { };
  kubectl-kopiur = pkgs.callPackage ./kubectl-kopiur.nix { };
  wagoapp = pkgs.callPackage ./wagoapp.nix { };
}
