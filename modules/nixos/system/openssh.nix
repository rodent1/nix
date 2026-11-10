{
  internal.nixosModules.default =
    { lib, ... }:
    {
      config = {
        services.openssh = {
          enable = true;
          openFirewall = true;
          # Don't allow home-directory authorized_keys
          authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
          settings = {
            # Harden
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            # Automatically remove stale sockets
            StreamLocalBindUnlink = "yes";
            # Allow forwarding ports to everywhere
            GatewayPorts = "clientspecified";
          };

        };

      };
    };
}
