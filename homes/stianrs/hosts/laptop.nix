{ config, ... }:
{
  modules = {
    development.enable = true;
    kubernetes.enable = true;
  };

  programs.fish.shellInit = ''
    set -Ux OP_CONNECT_HOST (jq -r .host ${config.sops.secrets.op_connect.path})
    set -Ux OP_CONNECT_TOKEN (jq -r .token ${config.sops.secrets.op_connect.path})
  '';
}
