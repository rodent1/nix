{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.editor.nixvim;
in {
  options.modules.editor.nixvim = {
    enable = lib.mkEnableOption "nixvim program";
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./bufferline.nix
    ./catppuccin.nix
    ./conform.nix
    # ./copilot.nix
    ./dashboard.nix
    ./harpoon.nix
    ./keymaps.nix
    ./lsp.nix
    ./lualine.nix
    ./notify.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./which-key.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      defaultEditor = true;
      luaLoader.enable = true;

      viAlias = true;
      vimAlias = true;
      globals.mapleader = " ";

      clipboard.providers.wl-copy.enable = true;

      opts = {
        timeoutlen = lib.mkDefault 500;
        number = true;
        relativenumber = true;
        signcolumn = "yes";
        ignorecase = true;
        smartcase = true;
        undofile = true;
        undodir.__raw = "vim.fn.expand(\"~/.config/nvim/undodir\")";

        # Tab defaults (might get overwritten by an LSP server)
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        smarttab = true;

        ruler = true;
        scrolloff = 5;
      };
    };

    # Set Neovim as the default app for man pages
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
    };
  };
}
