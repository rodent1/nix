{
  internal.homeModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        programs = {
          mise = {
            enable = true;
            package = pkgs.unstable.mise;
            enableFishIntegration = true;
          };
        };
      };
    };
}
