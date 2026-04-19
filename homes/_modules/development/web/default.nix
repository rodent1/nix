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
  options.modules.development.web = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable web development environment.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24
      unstable.bun
    ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.cache/.bun/bin"
    ];
  };
}
