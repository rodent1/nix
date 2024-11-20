{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.nvim;
  catppuccinCfg = config.modules.themes.catppuccin;
in
{
  options.modules.shell.nvim = {
    enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf cfg.enable {
    # Based on https://github.com/azuwis/lazyvim-nixvim

    programs.nixvim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      colorschemes = {
        catppuccin.enable = true;
        catppuccin.settings.flavour = catppuccinCfg.flavor;
      };

      extraPackages = with pkgs; [
        # LazyVim
        lua-language-server
        stylua
        # Telescope
        ripgrep
      ];

      extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

      extraConfigLua =
        let
          plugins = with pkgs.vimPlugins; [
            # LazyVim
            LazyVim
            bufferline-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            conform-nvim
            dashboard-nvim
            dressing-nvim
            flash-nvim
            friendly-snippets
            gitsigns-nvim
            grug-far-nvim
            indent-blankline-nvim
            lazydev-nvim
            lualine-nvim
            luvit-meta
            neo-tree-nvim
            noice-nvim
            nui-nvim
            nvim-cmp
            nvim-lint
            nvim-lspconfig
            nvim-notify
            nvim-snippets
            nvim-treesitter
            nvim-treesitter-textobjects
            nvim-ts-autotag
            persistence-nvim
            plenary-nvim
            snacks-nvim
            telescope-fzf-native-nvim
            telescope-nvim
            todo-comments-nvim
            trouble-nvim
            ts-comments-nvim
            which-key-nvim
            {
              name = "mini.ai";
              path = mini-nvim;
            }
            {
              name = "mini.icons";
              path = mini-nvim;
            }
            {
              name = "mini.pairs";
              path = mini-nvim;
            }
          ];
          mkEntryFromDrv =
            drv:
            if lib.isDerivation drv then
              {
                name = "${lib.getName drv}";
                path = drv;
              }
            else
              drv;
          lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
        in
        ''
          require("lazy").setup({
            defaults = {
              lazy = true,
            },
            dev = {
              -- reuse files from pkgs.vimPlugins.*
              path = "${lazyPath}",
              patterns = { "." },
              -- fallback to download
              fallback = true,
            },
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              -- The following configs are needed for fixing lazyvim on nix
              -- force enable telescope-fzf-native.nvim
              { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
              -- disable mason.nvim, use config.extraPackages
              { "williamboman/mason-lspconfig.nvim", enabled = false },
              { "williamboman/mason.nvim", enabled = false },
              -- use catppuccin colorscheme
              { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
              -- put this line at the end of spec to clear ensure_installed
              { "nvim-treesitter/nvim-treesitter", opts = function(_, opts) opts.ensure_installed = {} end },
            },
          })
        '';
    };

    # Set Neovim as the default app for man pages
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
      KUBE_EDITOR = "nvim";
    };
  };
}
