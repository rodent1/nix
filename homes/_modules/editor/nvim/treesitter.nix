{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazy.enable = true;
    plugins.lazy.plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
  };
}
