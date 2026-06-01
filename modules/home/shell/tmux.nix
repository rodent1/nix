{ ... }:
{
  flake.homeModules.shellTmux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.shell.tmux;
    in
    {
      options.modules.shell.tmux.enable = lib.mkEnableOption "tmux";

      config = lib.mkIf cfg.enable {
        programs.tmux = {
          enable = true;
          prefix = "C-s";
          sensibleOnTop = true;
          aggressiveResize = true;
          baseIndex = 1;
          clock24 = true;
          escapeTime = 10;
          focusEvents = true;
          historyLimit = 5000;
          mouse = true;
          shell = "${pkgs.fish}/bin/fish";
          terminal = "tmux-256color";

          extraConfig = ''
            set -sg terminal-overrides ",*:RGB"
            set -s extended-keys on
            set -as terminal-features 'xterm*:extkeys'
            set -g allow-passthrough on
            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            set-option -g status-position top
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
          '';

          plugins = with pkgs; [
            {
              plugin = tmuxPlugins.better-mouse-mode;
              extraConfig = ''
                set -g @emulate-scroll-for-no-mouse-alternate-buffer on
              '';
            }
            {
              plugin = tmuxPlugins.vim-tmux-navigator;
            }
          ];
        };

        catppuccin.tmux = {
          enable = true;
          extraConfig = ''
            set -g @catppuccin_window_status_style "rounded"
          '';
        };
      };
    };
}
