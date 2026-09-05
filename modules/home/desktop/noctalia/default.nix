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

        qt = {
          enable = true;
          platformTheme.name = "qtct";
          qt6ctSettings.Appearance = {
            color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
            custom_palette = true;
          };
        };

        services = {
          cliphist.enable = true;
          gnome-keyring.enable = true;
          xembed-sni-proxy.enable = true;
        };

        home.packages = with pkgs; [
          ffmpegthumbnailer
          file-roller
          kdePackages.dolphin
        ];
      };
    };
}
