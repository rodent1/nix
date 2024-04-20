{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.kubernetes;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [inputs.talhelper.packages.${pkgs.system}.default];
    })
  ];
}
