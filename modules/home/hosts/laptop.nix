{
  internal.homeModules.laptop = _: {
    config = {
      modules = {
        desktop = {
          enable = true;
          plasma.enable = true;
        };
        kubernetes.enable = true;
        development.go.enable = false;
      };
    };
  };
}
