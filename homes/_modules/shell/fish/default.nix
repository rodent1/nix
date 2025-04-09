{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (config.home) username homeDirectory;
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
    enableGreeting = lib.mkEnableOption "fish greeting" // {
      default = true;
    };
    enableGhFunctions = lib.mkEnableOption "GitHub CLI helper functions";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.fish = {
        enable = true;
        # FIXME: Switch back to stable once 4.0 is available
        # package = pkgs.fish;
        package = pkgs.unstable.fish;

        plugins = [
          {
            name = "done";
            inherit (pkgs.fishPlugins.done) src;
          }
          {
            name = "puffer";
            inherit (pkgs.fishPlugins.puffer) src;
          }
          {
            name = "autopair";
            inherit (pkgs.fishPlugins.autopair) src;
          }
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

          # Paths are in reverse priority order
          update_path /opt/homebrew/bin
          update_path ${homeDirectory}/.krew/bin
          update_path /nix/var/nix/profiles/default/bin
          update_path /run/current-system/sw/bin
          update_path /etc/profiles/per-user/${username}/bin
          update_path /run/wrappers/bin
          update_path ${homeDirectory}/.nix-profile/bin
          update_path ${homeDirectory}/go/bin
          update_path ${homeDirectory}/.cargo/bin
          update_path ${homeDirectory}/.local/bin
        '';

        functions = lib.mkMerge [
          (lib.mkIf cfg.enableGreeting {
            fish_greeting = {
              description = "Set the fish greeting";
              body = builtins.readFile ./functions/fish_greeting.fish;
            };
          })
          (lib.mkIf cfg.enableGhFunctions {
            ghce = {
              description = "gh copilot explain";
              body = builtins.readFile ./functions/ghce.fish;
            };
            ghcs = {
              description = "gh copilot suggest";
              body = builtins.readFile ./functions/ghcs.fish;
            };
          })
        ];
      };

      catppuccin.fish.enable = true;
    })

    (lib.mkIf (cfg.enable && isDarwin) {
      programs.fish = {
        functions = {
          flushdns = {
            description = "Flush DNS cache";
            body = builtins.readFile ./functions/flushdns.fish;
          };
        };
      };
    })
  ];
}
