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

            -- Application launchers recovered from the previous Hyprland configuration.
            hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd("ghostty"))
            hl.bind(mainMod .. "+B", hl.dsp.exec_cmd("google-chrome"))
            hl.bind(mainMod .. "+CTRL+B", hl.dsp.exec_cmd("google-chrome --incognito"))
            hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
            hl.bind(mainMod .. "+E", hl.dsp.exec_cmd("dolphin"))

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

            hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

            -- Noctalia panels
            hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
            hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
            hl.bind("ALT+Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

            -- Audio controls
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
            hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })

            -- Brightness keys
            hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up eDP-1 5"), { locked = true, repeating = true })
            hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down eDP-1 5"), { locked = true, repeating = true })
          '';
        };
      };
    };
}
