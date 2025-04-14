{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.shell.fish;
  sourceData = pkgs.callPackage ../../../../pkgs/_sources/generated.nix { };
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
          name = "puffer";
          inherit (pkgs.fishPlugins.puffer) src;
        }
        {
          name = "tmux-fish";
          inherit (sourceData.tmux-fish) src;
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
        ghce = {
          description = "gh copilot explain";
          body = builtins.readFile ./functions/ghce.fish;
        };
        ghcs = {
          description = "gh copilot suggest";
          body = builtins.readFile ./functions/ghcs.fish;
        };
      };
    };

    catppuccin.fish.enable = true;
  };
}
