{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.home) username homeDirectory;
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

      ]
      ++ [
        (lib.mkIf (config.programs.tmux.enable && !config.programs.zellij.enable) {
          name = "tmux-fish";
          inherit (sourceData.tmux-fish) src;
        })
      ];

      interactiveShellInit = ''
        function remove_path
          if set -l index (contains -i $argv[1] $PATH)
            set --erase --universal fish_user_paths[$index]
          end
        end

        function update_path
          if test -d $argv[1]
            fish_add_path -m $argv[1]
          else
            remove_path $argv[1]
          end
        end

        update_path /nix/var/nix/profiles/default/bin
        update_path /run/current-system/sw/bin
        update_path /etc/profiles/per-user/${username}/bin
        update_path /run/wrappers/bin
        update_path ${homeDirectory}/go/bin
        update_path ${homeDirectory}/.cargo/bin
        update_path ${homeDirectory}/.local/bin
        update_path ${homeDirectory}/.cache/.bun/bin

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
