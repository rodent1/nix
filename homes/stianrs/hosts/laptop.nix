_: {
  config = {
    modules = {
      desktop = {
        enable = true;
        noctalia.enable = true;
      };
      kubernetes.enable = false;
      development.go.enable = false;
      development.rust.enable = false;
    };

    home.file.".face".source = ../assets/profile.jpg;
  };
}
