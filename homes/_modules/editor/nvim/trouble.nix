{pkgs, ...}: let
  trouble-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "trouble-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "trouble.nvim";
      rev = "39595e883e2f91456413ca4df287575d31665940";
      hash = "sha256-KNCP1tNX1k6ohjMJjUYI/G35LmB3O9BAfhvox6+8Km0=";
    };
  };
in {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = [
      {
        pkg = trouble-nvim;
        dependencies = [
          pkgs.vimPlugins.telescope-nvim
        ];
        config = ''
          function()
            local actions = require("telescope.actions")
            local open_with_trouble = require("trouble.sources.telescope").open

            -- Use this to add more results without clearing the trouble list
            local add_to_trouble = require("trouble.sources.telescope").add

            local telescope = require("telescope")

            telescope.setup({
              defaults = {
                mappings = {
                  i = { ["<c-t>"] = open_with_trouble },
                  n = { ["<c-t>"] = open_with_trouble },
                },
              },
            })
          end
        '';
      }
    ];
    keymaps = [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      }
      {
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle focus=false<CR>";
      }
      {
        key = "<leader>cl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<CR>";
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<CR>";
      }
    ];
  };
}
