{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.tmux = {
        enable = true;

        clock24 = true;
        baseIndex = 1;
        mouse = true;

        extraConfig = ''
          set-option -g status-position top

          # remap prefix from 'C-b' to 'C-a'
          unbind C-b
          set-option -g prefix C-a
          bind-key C-a send-prefix

          # reload config file
          bind r source-file  ~/.config/tmux/tmux.conf \; display-message "Reloaded!"

          # split panes using | and -
          bind | split-window -h
          bind - split-window -v
          unbind '"'
          unbind %

          # switch panes using Alt-arrow without prefix
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D
        '';

        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.catppuccin.overrideAttrs (_: {
              version = "unstable-2023-11-01";
              src = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "tmux";
                rev = "47e33044b4b47b1c1faca1e42508fc92be12131a";
                hash = "sha256-kn3kf7eiiwXj57tgA7fs5N2+B2r441OtBlM8IBBLl4I=";
              };
            });

            extraConfig = ''
              set -g @catppuccin_flavour 'macchiato'       # frappe, latte, macchiato, mocha

              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"

              set -g @catppuccin_window_default_fill "number"
              set -g @catppuccin_window_default_text "#W"

              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#W"

              set -g @catppuccin_status_modules_right "directory user session"
              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator ""
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"

              set -g @catppuccin_directory_text "#{pane_current_path}"
            '';
          }
          {
            plugin = tmuxPlugins.better-mouse-mode;
            extraConfig = ''
              set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
            '';
          }
        ];
      };
    })
  ];
}
