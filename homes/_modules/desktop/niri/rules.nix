{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
in
{
  config = lib.mkIf cfg.enable {
    programs.niri.settings = {
      layer-rules = [
        {
          matches = [
            { namespace = "^noctalia-wallpaper*"; }
          ];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };

          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        {
          matches = [
            { app-id = "firefox"; }
          ];
          open-on-workspace = "browser";
        }
        {
          matches = [
            { app-id = "ghostty"; }
            { app-id = "vscode"; }
          ];
          open-on-workspace = "main";
        }
        {
          matches = [
            { app-id = "^1password$"; }
            { app-id = "org.gnome.Calculator"; }
            { app-id = "org.gnome.eog"; }
            { app-id = "org.gnome.Showtime"; }
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            { app-id = "vesktop"; }
          ];
          open-on-workspace = "discord";
        }
      ];

      debug.honor-xdg-activation-with-invalid-serial = { };
    };
  };
}
