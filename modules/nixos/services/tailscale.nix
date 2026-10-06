{
  internal.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.services.tailscale;
    in
    {
      options.modules.services.tailscale.enable = lib.mkEnableOption "Tailscale";

      config = lib.mkIf cfg.enable {
        services.tailscale = {
          enable = true;
          package = pkgs.unstable.tailscale;
          openFirewall = true;
        };
      };
    };
}
