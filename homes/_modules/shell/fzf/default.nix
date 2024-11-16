{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.shell.fzf;
in
{
  options.modules.shell.fzf = {
    enable = mkEnableOption "fzf configuration";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      tmux.enableShellIntegration = true;
      catppuccin.enable = true;

      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border=rounded"
        "--info=inline"
        "--preview-window='right:60%'"
        "--bind='ctrl-u:preview-half-page-up'"
        "--bind='ctrl-d:preview-half-page-down'"
      ];

      defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";

      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --hidden --exclude .git";
      fileWidgetOptions = [ "--preview 'bat --color=always -n {}'" ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = [ "--preview '${pkgs.eza}/bin/eza --all --color=always {} | head 200'" ];
    };

    home.packages = with pkgs; [
      bat # For file preview
      eza # For directory listing
      fd # For file finding
    ];
  };
}
