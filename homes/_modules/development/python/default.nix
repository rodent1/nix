{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.development;
in
{
  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        python3
      ])
      ++ (with pkgs.unstable; [
        uv
        ruff
      ]);
  };
}
