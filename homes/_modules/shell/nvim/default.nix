{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.editor.nixvim;
  catppuccinCfg = config.modules.themes.catppuccin;
in
{
  options.modules.editor.nixvim = {
    enable = lib.mkEnableOption "nixvim + jeezyvim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (jeezyvim.extend {
        colorschemes = {
          kanagawa.enable = false;
          catppuccin.enable = true;
          catppuccin.settings.flavour = catppuccinCfg.flavor;
        };

        viAlias = true;
        vimAlias = true;
      })
    ];

    # Set Neovim as the default app for man pages
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
    };
  };
}
