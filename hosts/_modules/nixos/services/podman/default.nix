{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.podman;
in {
  options.modules.services.podman = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        package = pkgs.unstable.podman;
        dockerCompat = true;
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
