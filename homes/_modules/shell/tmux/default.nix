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
  options.modules.shell.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      catppuccin.enable = true;

      prefix = "C-s";
      aggressiveResize = true;
      baseIndex = 1;
      historyLimit = 5000;
      mouse = true;
      terminal = "screen-256color";
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      secureSocket = false;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.better-mouse-mode;
          extraConfig = ''
            set -g @emulate-scroll-for-no-mouse-alternate-buffer on
          '';
        }
      ];

      catppuccin.extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"
      '';

      extraConfig = ''
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        set-option -g status-position top

        # Make the status line pretty and add some modules
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"
      '';
    };

    # Add TMUX autostart that works in WSL2
    programs.fish.shellInitLast = ''
      if status is-interactive
          # Skip tmux for VS Code and Vim terminal
          if test -z "$VSCODE_INJECTION" -a -z "$VIM"
              # Wait for user runtime directory
              while not test -d /run/user/(id -u)
                  sleep 0.5
              end

              # Start tmux if not already in a session
              if not set -q TMUX
                  tmux new-session -A -s Main
              end
          end
      end
    '';
  };
}
