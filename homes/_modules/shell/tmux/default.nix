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

        sensibleOnTop = false;
        baseIndex = 1;
        clock24 = true;
        mouse = true;

        extraConfig = ''
          set-option -g status-position top
          set -g mouse-select-pane on

          unbind r
          bind r source-file  ~/.config/tmux/tmux.conf \; display-message "Reloaded!"
        '';

        plugins = with pkgs; [
          tmuxPlugins.catppuccin
          tmuxPlugins.better-mouse-mode
          tmuxPlugins.vim-tmux-navigator
          tmuxPlugins.yank
          tmuxPlugins.sensible
        ];
      };
    })
  ];
}
