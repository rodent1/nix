{ config, lib, ... }:
let
  cfg = config.modules.security._1password;
in
{
  options.modules.security._1password = {
    enable = lib.mkEnableOption "_1password";
  };

  config = lib.mkIf (cfg.enable) {
    programs._1password = {
      enable = true;
    };
  };
}
