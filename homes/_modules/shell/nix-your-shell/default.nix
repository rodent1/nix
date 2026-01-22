{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.shell.nix-your-shell;
in
{
  options.modules.shell.nix-your-shell = {
    enable = lib.mkEnableOption "nix-your-shell";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
