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
          name = "tmux-fish";
          src = pkgs.fetchFromGitHub {
            owner = "budimanjojo";
            repo = "tmux-fish";
            rev = "db0030b7f4f78af4053dc5c032c7512406961ea5";
            hash = "sha256-rRibn+FN8VNTSC1HmV05DXEa6+3uOHNx03tprkcjjs8=";
          };
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
          body = builtins.readFile ./functions/fish_greeting.fish;
        };

        tempdir = {
          description = "Change to a new temporary directory";
          body = builtins.readFile ./functions/tempd.fish;
        };
      };
    };

    catppuccin.fish.enable = true;

    programs.zoxide = {
      enable = true;
    };
  };
}
