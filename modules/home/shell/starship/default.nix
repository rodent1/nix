{
  internal.homeModules.default =
    {
      ...
    }:
    {
      config = {
        programs.starship = {
          enable = true;
          enableFishIntegration = true;
        };
      };

    };
}
