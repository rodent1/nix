{
  internal.homeModules.desktop =
    { config, osConfig, ... }:
    {
      # Mirrors the Hyprland look and feel in hyprland.nix as closely as
      # Umbriel's settings allow.
      programs.umbriel = {
        enable = true;

        settings = {
          general = {
            autostart = [ "noctalia" ];
            focus_on_activate = true;
          };

          layout = {
            mode = "dwindle";
            gap = 4;
            dwindle.preserve_split = true;
          };

          appearance = {
            corner_radius = 8;
            border_width = 1;

            shadow = {
              enabled = true;
              softness = 4;
              offset_x = 0;
              offset_y = 0;
            };

            blur = {
              enabled = true;
              radius = 3;
              passes = 2;
            };
          };

          colors.shadow = "#1A1A1AEE";

          input = {
            keyboard = {
              inherit (osConfig.services.xserver.xkb) layout variant;
            };

            touchpad.natural_scroll = true;
            focus.follows_mouse = "sloppy";

            cursor = {
              theme = config.home.pointerCursor.name;
              inherit (config.home.pointerCursor) size;
            };
          };

          window_rule = [
            # Umbriel only blurs translucent windows that opt in.
            { blur = true; }
            {
              match.app_id = "^dev\\.noctalia\\.UmbrielSharePicker$";
              default_floating = true;
              default_floating_size_px = {
                width = 800;
                height = 600;
              };
            }
          ];
        };
      };
    };
}
