{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.services._1password;
in
{
  options.modules.services._1password = {
    enable = lib.mkEnableOption "_1password";
  };

  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      package = pkgs.unstable._1password-gui;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ "stianrs" ];
    };
  };
}
