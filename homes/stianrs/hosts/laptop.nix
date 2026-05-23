_: {
  config = {
    modules = {
      desktop = {
        enable = true;
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
    };

    wayland.windowManager.hyprland = {
      extraConfig = ''
        monitor = , preferred , auto, 1.5
      '';
    };

    home.file.".face".source = ../assets/profile.jpg;
  };
}
