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
  options.modules.development.python = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Python development environment.";
    };
  };

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
