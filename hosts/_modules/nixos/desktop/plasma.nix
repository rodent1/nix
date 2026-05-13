{
  config,
  lib,
  ...
}:
{
  config =
    lib.mkIf (config.modules.desktop.enable && config.modules.desktop.environments.plasma.enable)
      {
        services.desktopManager.plasma6.enable = true;
      };
}
