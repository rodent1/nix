_: {
  config = {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "name:Top, monitor:DP-2, default:true"
        "name:Discord, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false, monitor:DP-3, default:true"
        "name:Games, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false, monitor:DP-1"
      ];

      windowrule = [
        "match:initial_class vesktop, workspace name:Discord silent"
      ];

    };
  };
}
