{
  rodent.homeModules.default = _: {
    config = {
      programs.btop = {
        enable = true;
      };

      catppuccin.btop.enable = true;

      programs.fish = {
        shellAliases = {
          top = "btop";
        };
      };
    };
  };
}
