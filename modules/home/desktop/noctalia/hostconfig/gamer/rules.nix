{
  internal.homeModules.gamer =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.extraConfig = ''
          -- DP-2 is the top monitor
          hl.workspace_rule({
            workspace = "name:Top",
            monitor = "DP-2",
            default = true,
            persistent = true,
          })

          -- DP-3 is a dedicated, undecorated Discord display.
          hl.workspace_rule({
            workspace = "name:Discord",
            monitor = "DP-3",
            default = true,
            persistent = true,
            gaps_in = 0,
            gaps_out = 0,
            no_rounding = true,
            no_border = true,
            decorate = false,
          })

          -- Window rules
          hl.window_rule({
            match = { title = "^(Battle.net.*)$" },
            float = true,
            focus_on_activate = false,
          })
        '';

        programs.noctalia.settings.bar.default.monitor.DP-3.enabled = false;
      };
    };
}
