{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  myPackages,
  ...
}:

with lib;

let
  cfg = config.modules.users.stianrs;
in {
  imports = [
    ( import ../../home-manager { username="stianrs"; } )
  ];

  options.modules.users.stianrs = {
    enable = mkEnableOption "stianrs";
    enableDevTools = mkEnableOption "Enable dev tools" // {
      default = false;
    };
    enableKubernetesTools = mkEnableOption "Enable k8s tools" // {
      default = false;
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (pkgs.stdenv.isLinux) (import ./nixos.nix {inherit config;}))

    {
      users.users.stianrs = {
        shell = pkgs.fish;
      };

      modules.users.stianrs.home-manager.enable = true;

      modules.users.stianrs.sops = {
        defaultSopsFile = ./secrets.sops.yaml;
        secrets = {
          atuin_key = {
            path = "${config.home-manager.users.stianrs.xdg.configHome}/atuin/key";
          };
          mc_config = {
            path = "${config.home-manager.users.stianrs.home.homeDirectory}/.mc/config.json";
          };
        };
      };

      modules.users.stianrs.shell.atuin = {
        enable = true;
        package = pkgs-unstable.atuin;
        sync_address = "https://sh.rodent.cc";
        config = {
          key_path = config.home-manager.users.stianrs.sops.secrets.atuin_key.path;
        };
      };

      modules.users.stianrs.shell._1password = {
        enable = true;
        enableFishIntegration = true;
      };
      modules.users.stianrs.shell.bat = {
        enable = true;
        enableFishIntegration = true;
      };
      modules.users.stianrs.shell.btop = {
        enable = true;
        enableFishIntegration = true;
      };
      modules.users.stianrs.shell.doggo = {
        enable = true;
        enableFishIntegration = true;
      };
      modules.users.stianrs.shell.eza = {
        enable = true;
        enableFishIntegration = true;
      };
      modules.users.stianrs.shell.fish = {
        enable = true;
      };

      modules.users.stianrs.shell.git = {
        enable = true;
        username = "Stian R. Sporaland";
        email = "mail@stianrs.dev";
        signing = {
          signByDefault = true;
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
        };
        aliases = {
          co = "checkout";
          pl = "pull";
          l = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ (%cn)\" --decorate";
        };
        config = {
          gpg = {
            format = "ssh";
          };
          core = {
            autocrlf = "input";
          };
          init = {
            defaultBranch = "main";
          };
          pull = {
            rebase = true;
          };
          rebase = {
            autoStash = true;
          };
        };
        ignores = [
          # Mac OS X hidden files
          ".DS_Store"
          # Windows files
          "Thumbs.db"
          # asdf
          ".tool-versions"
          # mise
          ".mise.toml"
          # Sops
          ".decrypted~*"
          "*.decrypted.*"
          # Python virtualenvs
          ".venv"
        ];
      };

      modules.users.stianrs.shell.gh. enable = true;

      modules.users.stianrs.fonts.monaspace.enable = true;

      modules.users.stianrs.editor.nvim.enable = true;

      modules.users.stianrs.shell.direnv.enable = true;
      modules.users.stianrs.shell.minio-client.enable = true;
      modules.users.stianrs.shell.ssh.enable = true;
      modules.users.stianrs.shell.ssh-relay.enable = true;
      modules.users.stianrs.shell.starship.enable = true;
      modules.users.stianrs.shell.tmux.enable = true;
    }

    (mkIf (cfg.enableKubernetesTools) (import ./_kubernetes.nix {inherit pkgs; inherit pkgs-unstable; inherit myPackages;}))
    (mkIf (cfg.enableDevTools) (import ./_devtools.nix {inherit pkgs; inherit pkgs-unstable; inherit lib; inherit myPackages;}))
  ]);
}
