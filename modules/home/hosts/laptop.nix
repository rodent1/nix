{
  internal.homeModules.laptop = _: {
    config = {
      modules = {
        desktop = {
          enable = true;
          noctalia.enable = true;
        };
        kubernetes.enable = true;
      };
    };
  };
}
