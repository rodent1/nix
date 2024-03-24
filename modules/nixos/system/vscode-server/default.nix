{ pkgs, lib, config, vscode-server, nix-ld-rs, ... }:
with lib;

let
  cfg = config.modules.system.vscode-server;
in {
  options.modules.system.vscode-server = { enable = mkEnableOption "vscode-server"; };

  imports = [
    vscode-server.nixosModules.default
  ];

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      # package = nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
    };

    services.vscode-server.enable = true;

    # TODO: Find a way to add vscode-fix from ./modules/common/editor/vscode-server in here for all users managed by home-manager
  };
}
