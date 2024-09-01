{ lib, config, ... }:
let
  cfg = config.modules.security._1password;
in
{
  options.modules.security._1password = {
    enable = lib.mkEnableOption "_1password";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      # TODO: See if I can get this to work with home.sessionVariables instead
      programs.fish.shellInit = ''
        set -gx OP_CONNECT_HOST (jq -r .host ${config.sops.secrets.op_connect.path})
        set -gx OP_CONNECT_TOKEN (jq -r .token ${config.sops.secrets.op_connect.path})
      '';
    })
  ];
}
