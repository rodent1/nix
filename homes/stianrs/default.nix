{ pkgs, hostname, flake-packages, ... }: {
  imports = [
    ../_modules

    ./secrets
    ./hosts/${hostname}.nix
  ];

  modules = {
    editor = {
      nvim = {
        enable = true;
        package = flake-packages.${pkgs.system}.nvim;
        makeDefaultEditor = true;
      };
      vscode-server-fix.enable = true;
    };

    security = {
      ssh = {
        enable = true;
        matchBlocks = {
          "*" = { extraOptions = { IdentityAgent = "~/.ssh/agent.sock"; }; };
          "udm" = {
            extraOptions = {
              User = "root";
              Hostname = "10.1.1.1";
            };
          };

          "tank" = { extraOptions = { Hostname = "10.1.1.15"; }; };
        };
      };
    };

    shell = {
      fish.enable = true;

      git = {
        enable = true;
        username = "Stian R. Sporaland";
        email = "mail@stianrs.dev";
        signingKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
      };

      go-task.enable = true;

      mise = {
        enable = true;
        package = pkgs.unstable.mise;
      };
    };
  };
}
