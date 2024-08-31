{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs.unstable; [ _1password ];

    programs.fish.shellInit = ''
      set -Ux OP_CONNECT_HOST (jq -r .host ${config.sops.secrets.op_connect.path})
      set -Ux OP_CONNECT_TOKEN (jq -r .token ${config.sops.secrets.op_connect.path})
    '';
  };
}
