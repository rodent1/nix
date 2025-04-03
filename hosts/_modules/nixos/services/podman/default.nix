{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.services.podman;
in
{
  options.modules.services.podman = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;

        dockerCompat = true;

        # regular cleanup
        autoPrune.enable = true;
        autoPrune.dates = "weekly";

        # and add dns
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };

      oci-containers = {
        backend = "podman";
      };

      containers.registries.search = [ "docker.io" ];
    };

    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];
  };
}
