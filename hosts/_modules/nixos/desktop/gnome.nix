{
  config,
  lib,
  ...
}:
{
  config =
    lib.mkIf (config.modules.desktop.enable && config.modules.desktop.environments.gnome.enable)
      {
        services.desktopManager.gnome.enable = true;
      };
}
