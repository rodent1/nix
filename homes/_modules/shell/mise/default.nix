{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.shell.mise;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.modules.shell.mise = {
    enable = lib.mkEnableOption "mise";
    package = lib.mkPackageOption pkgs "mise" { };
    globalConfig = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
    };
    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.unstable.usage
    ];

    home.activation.miseInstall = ''
      ${lib.getExe cfg.package} install -C "${config.home.homeDirectory}"
      ${lib.getExe cfg.package} use -g usage
      ${lib.getExe cfg.package} completion fish > ~/.config/fish/completions/mise.fish
    '';

    xdg.configFile = {
      "mise/config.toml" = lib.mkIf (cfg.globalConfig != { }) {
        source = tomlFormat.generate "mise-config" cfg.globalConfig;
      };
      "mise/settings.toml" = {
        source = tomlFormat.generate "mise-settings" (
          {
            experimental = true;
            python_venv_auto_create = true;
            disable_hints = [
              "*"
            ];
          }
          // cfg.settings
        );
      };
    };

    programs = {
      bash.initExtra = ''
        eval "$(${lib.getExe cfg.package} activate bash)"
      '';

      fish.interactiveShellInit = lib.mkAfter ''
        ${lib.getExe cfg.package} activate fish | source
      '';

      fish.shellInit = lib.mkAfter ''
        ${lib.getExe cfg.package} activate fish --shims | source
      '';
    };
  };
}
