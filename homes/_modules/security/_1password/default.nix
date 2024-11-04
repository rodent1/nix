{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.security._1password-cli;
in
{
  options.modules.security._1password-cli = {
    enable = lib.mkEnableOption "_1password-cli";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      functions.op = {
        description = "1password cli";
        body = builtins.readFile ./op.fish;
      };
    };
    home.packages = with pkgs.unstable; [ _1password-cli ];
  };
}
