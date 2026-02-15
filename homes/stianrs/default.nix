{
  hostname,
  lib,
  isWSL,
  ...
}:
let
  git_name = "stianrs";
  git_email = "mail@stianrs.dev";
  git_signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
in
{
  imports = [
    ../_modules

    ./hosts/${hostname}.nix
  ];

  modules = {
    security = {
      ssh = {
        enable = true;
        matchBlocks = lib.mkMerge [
          {
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
          }
          (lib.mkIf (!isWSL) {
            "*" = {
              extraOptions = {
                identityAgent = "~/.1password/agent.sock";
              };
            };
          })
        ];
      };
    };

    shell = {
      atuin.enable = true;

      fish.enable = true;

      git = {
        enable = true;
        username = git_name;
        email = git_email;
        signingKey = git_signingKey;
      };

      jujutsu = {
        enable = true;
        username = git_name;
        email = git_email;
        signingKey = git_signingKey;
      };

      mise.enable = true;
      nix-your-shell.enable = true;
      nvim.enable = true;

      starship.enable = true;
      tmux.enable = true;
    };

    themes = {
      catppuccin = {
        enable = true;
        flavor = "mocha";
      };
    };
  };
}
