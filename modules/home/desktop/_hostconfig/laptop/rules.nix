_: {
  config.wayland.windowManager.hyprland.extraConfig = ''
    hl.workspace_rule({
      workspace = "name:Discord",
      no_rounding = true,
      decorate = false,
      gaps_in = 0,
      gaps_out = 0,
      no_border = true,
      default = true,
    })

    hl.window_rule({
      name = "Discord",
      match = {
        initial_class = "vesktop",
      },
      workspace = "name:Discord silent",
    })
  '';
}
