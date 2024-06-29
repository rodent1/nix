{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.services.vscode-server;
in {
  options.modules.services.vscode-server = {
    enable = lib.mkEnableOption "vscode-server";
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
