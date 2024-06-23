{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
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
        key = "<leader>pf";
        action = "<cmd>lua require('telescope.builtin').find_files()<CR>";
      }
      {
        key = "<leader>/";
        action = "<cmd>lua require('telescope.builtin').grep_string()<CR>";
      }
      {
        key = "<leader>pr";
        action = "<cmd>lua require('telescope.builtin').oldfiles()<CR>";
      }
      {
        key = "<leader>:";
        action = "<cmd>lua require('telescope.builtin').command_history()<CR>";
      }
    ];
  };
}
