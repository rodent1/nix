{
  internal.homeModules.desktop =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        xdg.desktopEntries.t3-code = {
          name = "T3 Code (Nightly)";
          exec = "${config.home.homeDirectory}/Apps/T3-Code.AppImage";
          terminal = false;
          categories = [ "Development" ];
          startupNotify = true;
        };
      };
    };
}
