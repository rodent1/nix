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
        programs.vesktop = {
          enable = true;
          package = pkgs.unstable.vesktop;
        };
      };
    };
}
