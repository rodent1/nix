_: {
  config = {
    modules = {
      desktop = {
        enable = true;
        noctalia.enable = true;
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = false;
    };

    programs.niri.settings = {
      outputs = {
        "eDP-1" = {
          enable = true;
          scale = 1.5;
        };
      };
    };

    home.file.".face".source = ../assets/profile.jpg;
  };
}
