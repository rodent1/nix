{
  internal.homeModules.desktop =
    {
      config,
      lib,
      ...
    }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        programs.codexDesktopLinux.enable = true;
      };
    };
}
