{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = [
      {
        pkg = pkgs.vimPlugins.harpoon2;
        dependencies = [
          pkgs.vimPlugins.plenary-nvim
        ];
        config = ''
          function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

            vim.keymap.set("n", "<leader>h1", function() harpoon:list():replace_at(1) end)
            vim.keymap.set("n", "<leader>h2", function() harpoon:list():replace_at(2) end)
            vim.keymap.set("n", "<leader>h3", function() harpoon:list():replace_at(3) end)
            vim.keymap.set("n", "<leader>h4", function() harpoon:list():replace_at(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
          end
        '';
      }
    ];
  };
}
