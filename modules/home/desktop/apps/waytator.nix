{ inputs, ... }:
{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        home.packages = [ inputs.waytator.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };
    };
}
