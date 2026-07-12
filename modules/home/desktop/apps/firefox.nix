{
  internal.homeModules.desktop =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.firefox = {
          enable = true;
        };
      };
    };
}
