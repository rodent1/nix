{ hostname, ... }:
{
  imports = [
    ../_modules

    ./secrets
    ./hosts/${hostname}.nix
  ];

  nixpkgs.config.allowUnfree = true;

  modules = {
    security = {
      ssh = {
        enable = true;
        matchBlocks = {
          "*" = {
            extraOptions = {
              IdentityAgent = "~/.ssh/agent.sock";
            };
          };
          "udm" = {
            extraOptions = {
              User = "root";
              Hostname = "10.1.1.1";
            };
          };
          "tank" = {
            extraOptions = {
              Hostname = "10.1.1.15";
            };
          };
        };
      };

      _1password-cli = {
        enable = true;
      };
    };

    shell = {
      fish.enable = true;
      git = {
        enable = true;
        username = "Stian R. Sporaland";
        email = "mail@stianrs.dev";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
      };
      nvim.enable = true;
      tmux.enable = true;
    };

    services = {
      ssh-relay = {
        enable = true;
      };
    };

    themes = {
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };
}
