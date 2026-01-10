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

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 50000;
      mouse = true;
      terminal = "tmux-256color";

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.better-mouse-mode;
          extraConfig = ''
            set -g @emulate-scroll-for-no-mouse-alternate-buffer on
          '';
        }
      ];

      extraConfig = ''
        set -a terminal-features 'xterm-256color:RGB'

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

    programs.fish.interactiveShellInit = ''
      set -gx fish_tmux_autoquit false
      set -gx fish_tmux_no_alias false

      set fish_tmux_autostart true
    '';

    catppuccin.tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"
      '';
    };
  };
}
