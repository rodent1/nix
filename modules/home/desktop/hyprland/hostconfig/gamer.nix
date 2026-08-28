{
  internal.homeModules.gamer =
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
          -- Match the current Plasma monitor layout on gamer.
          hl.monitor({ output = "DP-2", mode = "highrr", position = "0x0", scale = 1 })
          hl.monitor({ output = "DP-1", mode = "highrr", position = "0x1440", scale = 1, vrr = 1 })
          hl.monitor({ output = "DP-3", mode = "highrr", position = "2560x1189", scale = 1, transform = 3 })
          hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

          -- Keep numbered workspaces on the primary monitor.
          for i = 1, 10 do
            hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2", persistent = true })
          end

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

          hl.window_rule({
            name = "Discord",
            match = { initial_class = "vesktop" },
            workspace = "name:Discord silent",
          })
        '';

        programs.noctalia.settings.bar.default.monitor.DP-3.enabled = false;
      };
    };
}
