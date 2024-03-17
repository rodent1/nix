{ username }: {lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.tmux;

in {
  options.modules.users.${username}.shell.tmux = {
    enable = mkEnableOption "${username} tmux";

    config = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = false;

      clock24 = true;
      shell = "${pkgs.fish}/bin/fish";

      plugins = with pkgs;
      [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'macchiato' # or frappe, latte, mocha

            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
      ];

      extraConfig = ''
        set-option -g status-position top
      '';
    };
  };
}
