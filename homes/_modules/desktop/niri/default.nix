{
  config,
  hostname,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.environments.niri;
  hostConfig = ./hosts + "/${hostname}.nix";
in
{
  imports = [
    ./autostart.nix
    ./keybinds.nix
    ./noctalia.nix
    ./rules.nix
    ./settings.nix
  ]
  ++ lib.optional (builtins.pathExists hostConfig) hostConfig;

  options.modules.desktop.environments.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable niri compositor configuration";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional programs.niri.settings merged per host";
    };

    noctalia = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Noctalia shell integration for niri";
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Additional programs.noctalia-shell.settings merged per host";
      };
    };
  };

  config = lib.mkIf (config.modules.desktop.enable && cfg.enable) {
    programs.niri = {
      enable = true;
      inherit (cfg) settings;
    };
  };
}
