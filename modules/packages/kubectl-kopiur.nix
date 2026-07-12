{
  internal.packageRecipes.kubectl-kopiur = ./_recipes/kubectl-kopiur.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.kubectl-kopiur = pkgs.kubectl-kopiur;
    };
}
