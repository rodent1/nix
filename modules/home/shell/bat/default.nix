{
  rodent.homeModules.default = _: {
    config = {
      programs.bat = {
        enable = true;
      };

      catppuccin.bat.enable = true;

      programs.fish = {
        shellAliases = {
          cat = "bat";
        };
      };
    };
  };
}
