{
  config = {
    autoCmd = [
      # Remove trailing whitespace on save
      {
        event = "BufWrite";
        command = "%s/\\s\\+$//e";
      }

      # Open help in a vertical split
      {
        event = "FileType";
        pattern = "help";
        command = "wincmd L";
      }

      # Enable spellcheck for some filetypes
      {
        event = "FileType";
        pattern = [
          "tex"
          "latex"
          "markdown"
        ];
        command = "setlocal spell spelllang=en,fr";
      }
    ];
  };
}
