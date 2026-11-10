{
  internal.homeModules.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        programs.neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          initLua = ''
            -- bootstrap lazy.nvim, LazyVim and your plugins
            require("config.lazy")
          '';

          extraPackages = with pkgs; [
            ast-grep
            fd
            gcc
            lazygit
            luajitPackages.luarocks
            ripgrep
            stylua
            tree-sitter
            unzip
            xclip
          ];
        };

        home.file."${config.xdg.configHome}/nvim" = {
          source = ./_config/nvim;
          recursive = true;
        };

        # Set Neovim as the default app for man pages
        home.sessionVariables = {
          EDITOR = "nvim";
          MANPAGER = "nvim +Man!";
        };
      };
    };
}
