{ pkgs, lib, config, vscode-server, ... }:
with lib;

let
  cfg = config.modules.system.vscode-server;
  vscode-serverModule = vscode-server.nixosModules.default;
in {
  options.modules.system.vscode-server = { enable = mkEnableOption "vscode-server"; };

  imports = [
    vscode-serverModule
  ];

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    services.vscode-server.enable = true;
  };
}
