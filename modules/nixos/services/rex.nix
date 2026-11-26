{
  internal.nixosModules.default =
    { config, lib, ... }:
    {
      config = lib.mkMerge [
        { home-manager.users.stianrs.programs.rex.enable = true; }

        (lib.mkIf config.modules.desktop.enable {
          users.users.stianrs.linger = true;

          home-manager.users.stianrs.services.rex = {
            enable = true;
            # Rex joins the tailnet as its own node, separate from the host's
            # tailscaled, so each host needs a distinct node name. The first
            # start prints a sign-in link in `rex server status`.
            tailscale = {
              enable = true;
              hostname = "rex-${config.networking.hostName}";
            };
          };
        })
      ];
    };
}
