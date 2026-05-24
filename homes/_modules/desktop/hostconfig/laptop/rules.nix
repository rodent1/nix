_: {
  config = {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        "1, on-created-empty:vesktop"
      ];

      windowrule = [
        "match:initial_class vesktop, workspace 1 silent"
      ];
    };
  };
}
