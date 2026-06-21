_: {
  config = {
    wayland.windowManager.hyprland.extraConfig = ''
      hl.on("hyprland.start", function ()
        hl.exec_cmd("1password --silent")
        hl.exec_cmd("vesktop")
      end)
    '';
  };
}
