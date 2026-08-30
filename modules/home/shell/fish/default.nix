{
  internal.homeModules.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.modules.shell.fish;
    in
    {
      options.modules.shell.fish = {
        enable = lib.mkEnableOption "fish";
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.fish;
          description = "The fish shell package to use.";
        };
      };

      config = lib.mkIf cfg.enable {
        xdg.configFile."fish/conf.d/00-codex-runtime.fish".text = ''
          # Old Codex shell snapshots may contain ChatGPT Desktop's runtime
          # libraries. Native Nix programs must resolve their own libraries.
          if set -q CODEX_SHELL LD_LIBRARY_PATH
            set -e LD_LIBRARY_PATH
          end
        '';

        programs.fish = {
          enable = true;
          inherit (cfg) package;

          plugins = [
            {
              name = "done";
              inherit (pkgs.fishPlugins.done) src;
            }
            {
              name = "fzf-fish";
              inherit (pkgs.fishPlugins.fzf-fish) src;
            }
            {
              name = "bass";
              inherit (pkgs.fishPlugins.bass) src;
            }
            {
              name = "zoxide";
              src = pkgs.fetchFromGitHub {
                owner = "icezyclon";
                repo = "zoxide.fish";
                rev = "27a058a661e2eba021b90e9248517b6c47a22674";
                hash = "sha256-OjrX0d8VjDMxiI5JlJPyu/scTs/fS/f5ehVyhAA/KDM=";
              };
            }
          ];

          interactiveShellInit = ''
            # fzf-fish
            set -gx fzf_preview_dir_cmd eza --all --color=always
          '';

          functions = {
            fish_greeting = {
              description = "Set the fish greeting";
              body = builtins.readFile ./_config/functions/fish_greeting.fish;
            };

            tempdir = {
              description = "Change to a new temporary directory";
              body = builtins.readFile ./_config/functions/tempd.fish;
            };
          };
        };

        catppuccin.fish.enable = true;

        programs.zoxide = {
          enable = true;
        };
      };
    };
}
