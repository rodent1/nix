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
            hl.window_rule({
              match = { class = "dev.noctalia.Noctalia" },
              float = true,
              size = { 1080, 920 },
            })

            hl.window_rule({
              match = { class = "1password" },
              float = true,
              size = { 1080, 920 },
            })

            hl.window_rule({
              match = { class = "org.gnome.Loupe|org.gnome.Calculator|org.gnome.Nautilus|org.gnome.TextEditor|org.gnome.Showtime" },
              float = true,
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

            hl.window_rule({
              name = "Discord",
              match = { initial_class = "vesktop" },
              workspace = "name:Discord silent",
            })
          '';
        };
      };
    };
}
