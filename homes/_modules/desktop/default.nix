{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop;
  envCfg = cfg.environments;
in
{
  imports = [
    inputs.niri-flake.homeModules.niri
    ./base.nix
    ./compositor-base.nix
    ./gnome
    ./hyprland
    ./niri
    ./plasma
  ];

  options.modules.desktop = {
    enable = lib.mkEnableOption "desktop Home Manager modules";
  };

  config = {
    assertions = [
      {
        assertion =
          (!cfg.enable)
          || lib.any (enabled: enabled) [
            envCfg.niri.enable
            envCfg.hyprland.enable
            envCfg.gnome.enable
            envCfg.plasma.enable
          ];
        message = "modules.desktop.enable requires at least one enabled desktop environment";
      }
    ];

    xdg.portal.enable = lib.mkIf cfg.enable (lib.mkForce false);
  };
}
