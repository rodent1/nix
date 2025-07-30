{ hostname, pkgs, ... }:
{
  imports = [
    ../_modules

    ./secrets
    ./hosts/${hostname}.nix
  ];

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
      fish = {
        enable = true;
        # FIXME: Switch back to stable once 4.0 is available
        package = pkgs.unstable.fish;
      };

      gh.enable = true;

      git = {
        enable = true;
        username = "Stian R. Sporaland";
        email = "mail@stianrs.dev";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
      };

      mise = {
        enable = true;
        package = pkgs.unstable.mise;
      };

      atuin.enable = true;
      nvim.enable = true;

      starship.enable = true;

      tmux.enable = true;
      zellij.enable = false;
    };

    services = {
      ssh-relay = {
        enable = true;
      };
    };

    themes = {
      catppuccin = {
        enable = true;
        flavor = "mocha";
      };
    };
  };
}
