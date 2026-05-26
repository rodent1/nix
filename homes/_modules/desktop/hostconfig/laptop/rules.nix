_: {
  config = {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "name:Discord, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false, default:true"
      ];
      windowrule = [
        "match:initial_class vesktop, workspace name:Discord silent"
      ];
    };
  };
}
