{...}: {
  programs.nixvim = {
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
    ];
  };
}
