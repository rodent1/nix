{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.editors.nixvim.lazyPlugins.copilot;
in {
  options.editors.nixvim.lazyPlugins.copilot = {
    enable = lib.mkEnableOption "copilot";
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      plugins.lazy.plugins = [
        {
          pkg = pkgs.vimPlugins.copilot-lua;
          dependencies = [
            pkgs.vimPlugins.copilot-cmp
          ];
          cmd = "Copilot";
          event = "InsertEnter";
          config = ''
            function()
              require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
              })
              require("copilot_cmp").setup()
            end
          '';
        }
      ];
    };
  };
}
