{
  rodent.homeModules.desktop =
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
          hl.window_rule({
            name = "Suppress maximize events",
            match = {
              class = ".*"
            },
            suppress_event = "maximize",
          })

          hl.window_rule({
            name = "Fix some dragging issues with XWayland",
            match = {
              class = "^$",
              title = "^$",
              xwayland = 1,
              float = 1,
              fullscreen = 0,
              pin = 0,
            },
            no_focus = true,
          })

          hl.window_rule({
            name = "Float some apps",
            match = {
              class = "^(1password|org.pulseaudio.pavucontrol|org.gnome.Calculator|org.gnome.eog|org.gnome.Showtime|com.gabm.satty)$"
            },
            float = true,
          })
        '';
      };
    };
}
