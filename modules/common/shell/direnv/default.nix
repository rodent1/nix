{ username }: {lib, config, ... }:
with lib;
let
  cfg = config.modules.users.${username}.shell.direnv;
in {
  options.modules.users.${username}.shell.direnv = {
    enable = mkEnableOption "${username} direnv";

    config = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
    };
  };
}
