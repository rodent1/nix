{
  internal.homeModules.desktop =
    { config, lib, ... }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        programs.noctalia = {
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

            shell.screenshot = {
              directory = "${config.xdg.userDirs.pictures}/Screenshots";
              pipe_to_command = true;
              pipe_command = "waytator \"$NOCTALIA_SCREENSHOT_PATH\"";
            };
          };
        };
      };
    };
}
