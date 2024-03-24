{
  lib,
  config,
  flake-packages,
  ...
}:
let
  cfg = config.modules.kubernetes;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [
        flake-packages.kubecolor
      ];
    })
  ];
}
