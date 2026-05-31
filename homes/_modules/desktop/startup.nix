_: {
  config = {
    wayland.windowManager.hyprland.extraConfig = ''
      hl.on("hyprland.start", function ()
        hl.exec_cmd("uwsm app -- hypridle")
        hl.exec_cmd("uwsm app -- wayle")
        hl.exec_cmd("uwsm app -- 1password --silent")
        hl.exec_cmd("uwsm app -- vesktop")
      end)
    '';
  };
}
