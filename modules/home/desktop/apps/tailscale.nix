{
  internal.homeModules.desktop =
    { osConfig, ... }:
    {
      services.tailscale-systray.enable = osConfig.services.tailscale.enable;
    };
}
