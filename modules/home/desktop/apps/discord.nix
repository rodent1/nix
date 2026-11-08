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
        programs.discord = {
          enable = true;
          package = pkgs.unstable.discord;
        };
      };
    };
}
