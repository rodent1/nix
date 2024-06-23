{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    extraPackages = with pkgs; [
      fd
      ripgrep
    ];
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      {
        pkg = telescope-nvim;
        dependencies = [
          plenary-nvim
        ];
      }
    ];
    keymaps = [
      {
        key = "<leader>ff";
        action = "<cmd>lua require('telescope.builtin').find_files()<CR>";
      }
      {
        key = "<leader><leader>";
        action = "<cmd>lua require('telescope.builtin').git_files()<CR>";
      }
      {
        key = "<leader>/";
        action = "<cmd>lua require('telescope.builtin').grep_string()<CR>";
      }
      {
        key = "<leader>fr";
        action = "<cmd>lua require('telescope.builtin').oldfiles()<CR>";
      }
      {
        key = "<leader>:";
        action = "<cmd>lua require('telescope.builtin').command_history()<CR>";
      }
      {
        key = "<leader>\"";
        action = "<cmd>lua require('telescope.builtin').registers()<CR>";
      }
      # TODO: add workspace search
    ];
  };
}
