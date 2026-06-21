{ config, lib, ... }:
let
  cfg = config.modules.desktop.plasma;
in
{

  options.modules.desktop.plasma = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Plasma home-manager modules";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Do something
  };
}
