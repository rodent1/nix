{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        undo.enable = true;
      };
      settings = {
        pickers = {
          colorscheme.enable_preview = true;
        };
      };
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader><leader>" = "git_files";
        "<leader>fg" = "grep_string";
        "<leader>fr" = "oldfiles";
        "<leader>:" = "command_history";
        "<leader>\\" = "registers";
      };
    };
  };
}
