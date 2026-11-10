{
  internal.homeModules.desktop =
    { config, ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        systemd.enable = false;

        extraConfig = ''
          hl.on("hyprland.start", function()
            hl.exec_cmd("noctalia")
          end)

          hl.config({
            general = {
              gaps_in = 5,
              gaps_out = 10,
            },

            decoration = {
              rounding = 20,
              rounding_power = 2,

              shadow = {
                enabled = true,
                range = 4,
                render_power = 3,
                color = 0xee1a1a1a,
              },

              blur = {
                enabled = true,
                size = 3,
                passes = 2,
                vibrancy = 0.1696,
              },
            },

            input = {
              kb_layout = "no",
              kb_variant = "nodeadkeys",
              follow_mouse = 1,
              touchpad = {
                natural_scroll = true,
              },
            },

            gestures = {
              workspace_swipe_use_r = true,
            },

            dwindle = {
              preserve_split = true,
            },

            misc = {
              disable_hyprland_logo = true,
              focus_on_activate = true,
            },
          })
        '';
      };

      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    };
}
