{ config, lib, ... }:
let
  cfg = config.modules.themes.catppuccin;
in
{
  options.modules.themes = {
    catppuccin = {
      enable = lib.mkEnableOption "catppuccin";
      flavor = lib.mkOption {
        type = lib.types.str;
        default = false;
      };
    };

    catppuccin.cursors = {
      enable = lib.mkEnableOption "catppuccin cursors";
      flavor = lib.mkOption {
        type = lib.types.str;
        default = false;
      };
      accent = lib.mkOption {
        type = lib.types.str;
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    catppuccin = {
      inherit (cfg) flavor;

      cursors = {
        inherit (cfg.cursors) enable flavor accent;
      };
    };
  };
}
