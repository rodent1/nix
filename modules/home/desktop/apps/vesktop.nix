{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        package = pkgs.unstable.vesktop;
      };
    };
}
