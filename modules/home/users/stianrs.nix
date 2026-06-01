{ self, ... }:
let
  hostModules = {
    gamer = self.homeModules.stianrsHostGamer;
    laptop = self.homeModules.stianrsHostLaptop;
    work = self.homeModules.stianrsHostWork;
  };
in
{
  flake.homeModules = {
    stianrs =
      {
        availableHomeModules ? { },
        hostname,
        lib,
        isWSL,
        ...
      }:
      let
        git_name = "Stian R. Sporaland";
        git_email = "mail@stian.rs";
        git_signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
      in
      {
        imports = [
          availableHomeModules.defaults
          availableHomeModules.mutability
          availableHomeModules.desktop
          availableHomeModules.development
          availableHomeModules.kubernetes
          availableHomeModules.security
          availableHomeModules.shell
          availableHomeModules.themes
        ]
        ++ lib.optional (builtins.hasAttr hostname hostModules) hostModules.${hostname};

        home = {
          username = lib.mkDefault "stianrs";
          homeDirectory = lib.mkDefault "/home/stianrs";
        };

        modules = {
          security.ssh = {
            enable = true;
            settings = lib.mkMerge [
              {
                "udm" = {
                  User = "root";
                  Hostname = "10.1.1.1";
                };
                "tank" = {
                  Hostname = "10.1.1.15";
                };
              }
              (lib.mkIf (!isWSL) {
                "*" = {
                  identityAgent = "~/.1password/agent.sock";
                };
              })
            ];
          };

          shell = {
            atuin.enable = true;
            fish.enable = true;
            git = {
              enable = true;
              name = git_name;
              email = git_email;
              signingKey = git_signingKey;
            };
            mise.enable = true;
            nix-your-shell.enable = true;
            nvim.enable = true;
            starship.enable = true;
            tmux.enable = true;
          };

          themes.catppuccin = {
            enable = true;
            flavor = "mocha";
          };
        };
      };

    stianrsHostGamer = _: {
      config.modules = {
        desktop.enable = true;
        kubernetes.enable = true;
        development.go.enable = false;
      };
    };

    stianrsHostLaptop = _: {
      config.modules = {
        desktop.enable = true;
        kubernetes.enable = true;
        development.go.enable = false;
      };
    };

    stianrsHostWork = _: {
      modules = {
        kubernetes.enable = false;
        development.go.enable = false;
      };
    };
  };
}
