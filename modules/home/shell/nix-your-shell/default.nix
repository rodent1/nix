{
  internal.homeModules.default =
    {
      ...
    }:
    {
      config = {
        programs.nix-your-shell = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
}
