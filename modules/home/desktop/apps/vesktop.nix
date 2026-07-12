{
  internal.homeModules.desktop =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.vesktop = {
          enable = true;
          settings = {
            minimizeToTray = true;
            arRPC = true;
          };

          vencord.settings = {
            frameless = true;
          };
        };
      };
    };
}
