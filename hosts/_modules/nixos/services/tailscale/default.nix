{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf (cfg.enable) {
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
    };
  };
}
