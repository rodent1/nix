_: {
  config = {
    modules = {
      desktop = {
        enable = true;
        environments = {
          niri.enable = true;
          hyprland.enable = true;
        };
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
    };

    home.file.".face".source = ../assets/profile.jpg;
  };
}
