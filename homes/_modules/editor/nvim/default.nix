{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.editor.neovim;
in {
  options.modules.editor.neovim = {enable = lib.mkEnableOption "neovim";};

  config = lib.mkIf cfg.enable {
    home.packages = [
      (inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        module = {
          imports = [./config/default.nix];
        };
      })
    ];
  };
}
