{
  internal.homeModules.default =
    { ... }:
    {
      config = {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
        };
      };
    };
}
