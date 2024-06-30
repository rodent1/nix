{ ... }:
{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          lspBuf = {
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
          diagnostic = {
            gj = "goto_next";
            gk = "goto_prev";
          };
        };
      };
      lspsaga = {
        enable = true;
        lightbulb = {
          enable = false;
          virtualText = false;
        };
        outline.keys.jump = "<cr>";
        hover = {
          openCmd = "!firefox";
        };
        ui.border = "rounded";
        scrollPreview = {
          scrollDown = "<c-d>";
          scrollUp = "<c-u>";
        };
      };
    };
  };
}
