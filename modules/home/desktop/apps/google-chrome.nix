{
  internal.homeModules.default =
    { config, lib, ... }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.google-chrome = {
          enable = true;

          commandLineArgs = [
            "--enable-features=MiddleClickAutoscroll"
          ];
        };
      };
    };
}
