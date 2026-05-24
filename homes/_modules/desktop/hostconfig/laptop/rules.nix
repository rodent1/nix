_: {
  config = {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "name:Discord, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false, default:true, on-created-empty:vesktop"
      ];

      windowrule = [
        "match:initial_class vesktop, workspace name:Discord silent"
        "match:initial_class 1password, float on"
      ];
    };
  };
}
