{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.shell.mise;
in
{
  options.modules.shell.mise = {
    enable = lib.mkEnableOption "mise";
    package = lib.mkPackageOption pkgs "mise" {
      default = pkgs.mise;
    };
  };

  config = lib.mkIf cfg.enable {

    programs = {
      mise = {
        enable = true;
        package = cfg.package;
        enableFishIntegration = false;
      };

      fish.shellInit = ''
        if status is-interactive
          ${lib.getExe cfg.package} activate fish | source
        else
          ${lib.getExe cfg.package} activate fish --shims | source
        end
      '';
    };
  };
}
