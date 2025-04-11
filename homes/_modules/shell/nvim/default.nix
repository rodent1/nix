{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.nvim;
in
{
  options.modules.shell.nvim = {
    enable = lib.mkEnableOption "nvim";
  };

  config = lib.mkIf cfg.enable {

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraLuaConfig = ''
        vim.g.mapleader = " "

        -- bootstrap lazy.nvim, LazyVim and your plugins
        require("config.lazy")
      '';

      extraPackages = with pkgs; [
        ast-grep
        gcc
        ripgrep
        stylua
        tree-sitter
        unzip
      ];
    };

    home.file."${config.xdg.configHome}/nvim" = {
      source = ./cfg;
      recursive = true;
    };

    # Set Neovim as the default app for man pages
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
      KUBE_EDITOR = "nvim";
    };
  };
}
