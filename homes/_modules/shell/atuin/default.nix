{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.atuin;
in
{
  options.modules.shell.atuin = {
    enable = lib.mkEnableOption "atuin";
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      package = pkgs.unstable.atuin;
      flags = [ "--disable-up-arrow" ];

      settings = {
        sync_address = "https://sh.rodent.cc";
        key_path = "${config.xdg.configHome}/atuin/key";
        style = "auto";
        sync.records = true;
        sync_frequency = "0";
      };
    };
  };
}
