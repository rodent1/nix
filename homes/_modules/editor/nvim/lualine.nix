{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = lualine-nvim;
        dependencies = [nvim-web-devicons];
        config = ''
          function()
            require('lualine').setup()
          end
        '';
      }
    ];
  };
}
