{
  flake.modules.nixos.ssh-server =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          # Harden
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          # Automatically remove stale sockets
          StreamLocalBindUnlink = "yes";
          # Allow forwarding ports to everywhere
          GatewayPorts = "clientspecified";
          # Allow X11 forwarding
          X11Forwarding = true;
        };
      };
    };
}
