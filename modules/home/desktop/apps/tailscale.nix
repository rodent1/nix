{
  internal.homeModules.desktop =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    {
      config = lib.mkIf config.modules.desktop.enable {
        services.tailscale-systray.enable = osConfig.services.tailscale.enable;
      };
    };
}
