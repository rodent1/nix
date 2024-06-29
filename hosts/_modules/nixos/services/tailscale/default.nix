{
  config,
  lib,
  ...
}: let
  cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf (cfg.enable) {
    services.tailscale = {
      enable = true;
    };

    programs.fish.interactiveShellInit = ''
      tailscale completion fish | source
    '';
  };
}
