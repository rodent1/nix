{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell._1password;
in {
   options.modules.users.${username}.shell._1password = {
    enable = mkEnableOption "${username} _1password";
    enableFishIntegration = mkEnableOption "${username} _1password fish integration";
    package = mkPackageOption pkgs "_1password" { };
  };

  config = mkIf (cfg.enable) ({
    environment.systemPackages = [
      cfg.package
    ];

    home-manager.users.${username}.programs.fish = mkIf (cfg.enableFishIntegration) ({
      shellAliases = {
        op = "op.exe";
      };
    });
  });
}
