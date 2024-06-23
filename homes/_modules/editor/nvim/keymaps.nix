{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = [
      {
        # TODO: This isn't working atm
        pkg = pkgs.vimPlugins.which-key-nvim;
        event = "VeryLazy";
        init = ''
          function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
          end
        '';
      }
    ];
    keymaps = [
      {
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "<leader>g";
        action = "<cmd>help<CR>";
      }
      {
        mode = "n";
        key = "<leader>pv";
        action = "<cmd>lua vim.cmd.Ex()<CR>";
      }
      {
        mode = "n";
        key = "<leader>ce";
        action = "<cmd>lua vim.diagnostic.setqflist()<CR>";
      }
    ];
  };
}
