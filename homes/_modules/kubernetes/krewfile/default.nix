{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.kubernetes;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.krewfile = {
        enable = true;
        krewPackage = pkgs.krew;
        plugins = [
          "node-shell"
          "cnpg"
          "rook-ceph"
        ];
      };
    })
  ];
}
