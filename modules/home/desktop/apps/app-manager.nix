{ inputs, ... }:
{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
      home.packages = [ inputs.app-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
