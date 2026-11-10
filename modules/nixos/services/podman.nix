{
  internal.nixosModules.default =
    {
      pkgs,
      ...
    }:
    {
      config = {
        virtualisation = {
          podman = {
            enable = true;

            dockerCompat = true;

            # regular cleanup
            autoPrune = {
              enable = true;
              dates = "weekly";
              flags = [ "--all" ];
            };

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
    };
}
