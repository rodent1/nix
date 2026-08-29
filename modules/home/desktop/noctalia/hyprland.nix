{
  internal.homeModules.desktop =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;

          extraConfig = ''

            hl.on("hyprland.start", function()
              hl.exec_cmd("noctalia")
              hl.exec_cmd("systemctl --user start plasma-kwallet-pam.service")
              hl.exec_cmd("systemctl --user start plasma-xembedsniproxy.service")
              hl.exec_cmd("vesktop")
              hl.exec_cmd("1password --silent")
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
      };
    };
}
