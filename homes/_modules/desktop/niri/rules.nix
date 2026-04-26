{
  ...
}:

{
  programs.niri.settings = {
    window-rules = [
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
          { app-id = "thunar"; }
        ];
        open-on-workspace = "main";
        open-maximized = true;
      }

      # Discord
      {
        matches = [
          { app-id = "vesktop"; }
        ];
        open-on-workspace = "discord";
      }

      {
        matches = [ { } ];
        geometry-corner-radius = {
          top-left = 20.0;
          top-right = 20.0;
          bottom-left = 20.0;
          bottom-right = 20.0;
        };
        clip-to-geometry = true;
      }
    ];
  };
}
