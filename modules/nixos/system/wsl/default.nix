{ pkgs, lib, config, nixos-wsl, ... }:
with lib;

let
  cfg = config.modules.system.wsl;
  wslModule = nixos-wsl.nixosModules.default;
in {
  options.modules.system.wsl = { enable = mkEnableOption "wsl"; };

  imports = [
    wslModule
  ];

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = "stianrs";
    };
    environment.systemPackages = with pkgs; [
      wslu
    ];
  };
}
