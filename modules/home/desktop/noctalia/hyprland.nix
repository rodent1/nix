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
            local mainMod = "SUPER"
            local ipc = "noctalia msg "

            hl.config({
              general = {
                gaps_in = 5,
                gaps_out = 10,
                border_size = 2,
                layout = "dwindle",
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

            -- Application launchers recovered from the previous Hyprland configuration.
            hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd("ghostty"))
            hl.bind(mainMod .. "+B", hl.dsp.exec_cmd("google-chrome-stable"))
            hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
            hl.bind(mainMod .. "+E", hl.dsp.exec_cmd("nautilus"))

            -- Window management.
            hl.bind(mainMod .. "+Q", hl.dsp.window.close())
            hl.bind(mainMod .. "+F", hl.dsp.window.float({ action = "toggle" }))
            hl.bind(mainMod .. "+M", hl.dsp.window.fullscreen_state({ internal = 1, client = 0 }))
            hl.bind(mainMod .. "+left", hl.dsp.focus({ direction = "l" }))
            hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "r" }))
            hl.bind(mainMod .. "+up", hl.dsp.focus({ direction = "u" }))
            hl.bind(mainMod .. "+down", hl.dsp.focus({ direction = "d" }))
            hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag())
            hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize())

            for i = 1, 9 do
              hl.bind(mainMod .. "+code:1" .. tostring(i - 1), hl.dsp.focus({ workspace = tostring(i) }))
              hl.bind(mainMod .. "+SHIFT+code:1" .. tostring(i - 1), hl.dsp.window.move({ workspace = tostring(i) }))
            end

            -- Noctalia v5 panels and hardware controls.
            hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
            hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
            hl.bind("ALT+Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
            hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })

            hl.window_rule({
              match = { class = "dev.noctalia.Noctalia" },
              float = true,
              size = { 1080, 920 },
            })

            hl.layer_rule({
              name = "noctalia",
              match = {
                namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
              },
              no_anim = true,
              ignore_alpha = 0.5,
              blur = true,
              blur_popups = true,
            })
          '';
        };
      };
    };
}
