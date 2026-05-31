_: {
  config = {
    wayland.windowManager.hyprland.extraConfig = ''
      hl.workspace_rule({
        workspace = "name:Top",
        monitor = "DP-2",
        default = true,
      })

      hl.workspace_rule({
        workspace = "name:Discord",
        no_rounding = true,
        decorate = false,
        gaps_in = 0,
        gaps_out = 0,
        no_border = true,
        monitor = "DP-3",
        default = true,
      })

      hl.workspace_rule({
        workspace = "name:Games",
        no_rounding = true,
        decorate = false,
        gaps_in = 0,
        gaps_out = 0,
        no_border = true,
        monitor = "DP-1",
      })

      hl.window_rule({
        name = "Discord",
        match = {
          initial_class = "vesktop",
        },
        workspace = "name:Discord silent",
      })

      hl.window_rule({
        name = "Battle.net",
        match = {
          initial_title = "Battle.net",
        },
        float = true,
        workspace = "name:Top silent",
      })

      hl.window_rule({
        name = "Steam",
        match = {
          initial_class = "steam",
        },
        float = true,
        workspace = "name:Top silent",
      })

      hl.window_rule({
        name = "Path of Exile",
        match = {
          initial_title = ".*Path of Exile.*",
        },
        workspace = "name:Games",
      })

      hl.window_rule({
        name = "World of Warcraft",
        match = {
          initial_title = ".*World of Warcraft.*",
        },
        workspace = "name:Games",
      })
    '';
  };
}
