{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.minio-client;
in {
   options.modules.users.${username}.shell.minio-client = {
    enable = mkEnableOption "${username} minio-client";
    package = mkPackageOption pkgs "minio-client" { };
  };

  config = mkIf (cfg.enable) ({
    environment.systemPackages = [
      cfg.package
    ];
  });
}
