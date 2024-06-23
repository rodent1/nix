{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      stylua
    ];
    plugins.lazy.enable = true;
    plugins.lazy.plugins = [
      {
        pkg = pkgs.vimPlugins.conform-nvim;
        opts = {
          formatters_by_ft = {
            lua = ["stylua"];
            nix = ["alejandra"];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
        };
      }
    ];
    keymaps = [
      {
        key = "<leader>cf";
        action = "<cmd>lua require(\"conform\").format()<CR>";
      }
    ];
  };
}
