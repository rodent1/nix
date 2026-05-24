_: {
  config = {
    modules = {
      desktop = {
        enable = true;
      };
      kubernetes.enable = true;
      development.go.enable = false;
      development.rust.enable = true;
    };
  };
}
