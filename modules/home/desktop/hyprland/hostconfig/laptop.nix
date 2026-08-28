{
  internal.homeModules.laptop =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.desktop.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.extraConfig = ''
          hl.monitor({
            output = "eDP-1",
            mode = "2880x1800@60",
            position = "0x0",
            scale = 1.6,
            bitdepth = 10,
            cm = "hdr",
          })

          -- unscale XWayland
          hl.config({
            xwayland = {
              force_zero_scaling = true
            }
          })

          -- toolkit-specific scale
          hl.env("GDK_SCALE", "2")
          hl.env("XCURSOR_SIZE", "32")

          -- brightness keys
          hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up eDP-1 5"), { locked = true, repeating = true })
          hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down eDP-1 5"), { locked = true, repeating = true })

          -- Keep the first two numbered bindings while giving the workspaces
          -- stable names in Noctalia and other desktop UI.
          hl.workspace_rule({
            workspace = "1",
            default_name = "Discord",
            monitor = "eDP-1",
            default = true,
            persistent = true,
            gaps_in = 0,
            gaps_out = 0,
            no_rounding = true,
            no_border = true,
            decorate = false,
          })
          hl.workspace_rule({ workspace = "2", default_name = "Browser", monitor = "eDP-1", persistent = true })

          hl.window_rule({
            name = "Discord",
            match = { initial_class = "vesktop" },
            workspace = "1 silent",
          })
          hl.window_rule({
            name = "Browser",
            match = { initial_class = "Google-chrome" },
            workspace = "2 silent",
          })
        '';

        programs.noctalia.settings.brightness = {
          minimum_brightness = 0.01;
          monitor.eDP-1 = {
            backend = "backlight";
            backlight_device = "intel_backlight";
          };
        };
      };
    };
}
