{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.services.vscode-server;
in {
  imports = [
    inputs.vscode-server.nixosModules.default
  ];

  options.modules.services.vscode-server = {
    enable = lib.mkEnableOption "vscode-server";
  };

  config = lib.mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
