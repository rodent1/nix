{
  internal.nixosModules.wsl =
    { lib, pkgs, ... }:
    {
      config = {
        wsl = {
          enable = true;
          defaultUser = "stianrs";

          wslConf = {
            interop.appendWindowsPath = false;
            network.generateHosts = false;
          };
        };

        # Windows tools commonly expect a conventional Linux filesystem layout
        # when launching commands inside WSL. In particular, Codex Desktop starts
        # its shell through /usr/bin/bash, which NixOS does not provide by default.
        system.activationScripts.usrbinbash = lib.stringAfter [ "usrbinenv" ] ''
          mkdir -p /usr/bin
          chmod 0755 /usr/bin
          ln -sfn ${pkgs.bashInteractive}/bin/bash /usr/bin/bash
        '';
      };
    };
}
