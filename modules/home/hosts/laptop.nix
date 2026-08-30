{
  internal.homeModules.laptop = _: {
    config = {
      modules = {
        desktop = {
          enable = true;
          noctalia.enable = true;
          plasma.enable = true;
        };
        kubernetes.enable = true;
      };
    };
  };
}
