{
  config,
  lib,
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
    programs.fish.interactiveShellInit = ''
      set -gx OP_SERVICE_ACCOUNT_TOKEN (cat ${config.sops.secrets.op_service_account_token.path})
    '';

    home.packages = with pkgs; [
      _1password-cli
    ];
  };
}
