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
        # Enable true color support for vim
        set -sg terminal-overrides ",*:RGB"

        set -s extended-keys on
        set -as terminal-features 'xterm*:extkeys'

        set -g allow-passthrough on

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

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.better-mouse-mode;
          extraConfig = ''
            set -g @emulate-scroll-for-no-mouse-alternate-buffer on
          '';
        }
        # {
        #   plugin = tmuxPlugins.resurrect;
        #   extraConfig = ''
        #     set -g @resurrect-strategy-vim 'session'      # Restore vim sessions
        #     set -g @resurrect-strategy-nvim 'session'     # Restore neovim sessions
        #     set -g @resurrect-capture-pane-contents 'on'  # Save pane contents
        #   '';
        # }
        # {
        #   plugin = tmuxPlugins.continuum;
        #   extraConfig = ''
        #     set -g @continuum-restore 'on'         # Auto-restore last saved session
        #     set -g @continuum-boot 'on'            # Auto-start tmux on boot
        #     set -g @continuum-save-interval '10'   # Save every 10 minutes
        #   '';
        # }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
        }
      ];
    };

    programs.fish.interactiveShellInit = ''
      # don't nest inside another tmux
      if not set -q TMUX
        # Create session 'main' or attach to 'main' if already exists.
        tmux new-session -A -s main
      end
    '';

    catppuccin.tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"
      '';
    };
  };
}
