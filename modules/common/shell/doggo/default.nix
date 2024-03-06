{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.doggo;
in {
   options.modules.users.${username}.shell.doggo = {
    enable = mkEnableOption "${username} doggo";
    enableFishIntegration = mkEnableOption "${username} doggo fish integration";
    package = mkPackageOption pkgs "doggo" { };
  };

  config = mkIf (cfg.enable) ({
    environment.systemPackages = [
      cfg.package
    ];

    home-manager.users.${username}.programs.fish = mkIf (cfg.enableFishIntegration) ({
      shellAliases = {
        dig = "doggo";
      };
    });
  });
}
