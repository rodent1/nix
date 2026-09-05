{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      options.modules.desktop.noctalia.enable = lib.mkEnableOption "Noctalia home configuration";

      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        programs.noctalia = {
          enable = true;
          systemd.enable = false;
          settings = {
            shell = {
              font_family = "Inter";
              polkit_agent = true;
              launch_apps_as_systemd_services = true;
            };

            theme.templates = {
              enable_builtin_templates = true;
              builtin_ids = [ "qt" ];
            };

            bar.default = {
              start = [
                "workspaces"
              ];
              center = [
                "clock"
                "weather"
              ];
              end = [
                "notifications"
                "tray"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "control-center"
                "session"
              ];
            };

            plugins = {
              enabled = [ "noctalia/wallhaven" ];
              auto_update = "all";
            };

            location.address = "Forsand Sandnes";

            idle.behavior = {
              lock = {
                enabled = true;
                timeout = 300;
                action = "lock";
              };
              "screen-off" = {
                enabled = true;
                timeout = 330;
                action = "screen_off";
              };
            };
          };
        };

        services = {
          cliphist.enable = true;
          gnome-keyring.enable = true;
          xembed-sni-proxy.enable = true;
        };

        home.pointerCursor = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        xdg.mimeApps = {
          enable = true;

          defaultApplications = {
            "image/png" = [ "org.gnome.Loupe.desktop" ];
            "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
            "image/webp" = [ "org.gnome.Loupe.desktop" ];
            "image/gif" = [ "org.gnome.Loupe.desktop" ];

            "video/mp4" = [ "org.gnome.Showtime.desktop" ];
            "video/x-matroska" = [ "org.gnome.Showtime.desktop" ];
            "video/webm" = [ "org.gnome.Showtime.desktop" ];

            "text/plain" = [ "org.gnome.TextEditor.desktop" ];
          };
        };

        gtk.enable = true;

        home.packages = with pkgs; [
          file-roller
          gnome-calculator
          gnome-text-editor
          nautilus
          loupe
          showtime
        ];
      };
    };
}
