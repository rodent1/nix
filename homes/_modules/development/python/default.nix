{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;
  python = pkgs.python3.withPackages (
    ps: with ps; [
      pip
    ]
  );
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      python
    ];
  };
}
