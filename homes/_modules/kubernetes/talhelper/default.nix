{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.kubernetes;
  talhelper = (builtins.getFlake "github:budimanjojo/talhelper/e9e594caa2e54fe1bc222c57bb167b574af8e061").packages.${pkgs.system}.default;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [talhelper];
    })
  ];
}
