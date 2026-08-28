{
  internal.homeModules.laptop = _: {
    config = {
      modules = {
        desktop = {
          enable = true;
          hyprland.enable = true;
          plasma.enable = true;
        };
        kubernetes.enable = true;
      };
    };
  };
}
