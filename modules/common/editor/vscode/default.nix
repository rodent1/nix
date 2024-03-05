{ username }: args@{pkgs, lib, myLib, config, ... }:
with lib;

let
  vscode-extensions = (import ./extensions.nix){pkgs = pkgs;};
  cfg = config.modules.users.${username}.editor.vscode;

  userDir = if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Application Support/Code/User"
  else
    "${config.home-manager.users.${username}.xdg.configHome}/Code/User";
  configFilePath = "${userDir}/settings.json";

  defaultExtensions = with vscode-extensions; [
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons
    elagil.pre-commit-helper
    esbenp.prettier-vscode
    gruntfuggly.todo-tree
    ionutvmi.path-autocomplete
    redhat.vscode-yaml
    shipitsmarter.sops-edit
    tamasfe.even-better-toml
  ];
  defaultConfig = (import ./defaultConfig.nix args);

in {
   options.modules.users.${username}.editor.vscode = {
    enable = mkEnableOption "${username} vscode";
    package = mkPackageOption pkgs "vscode" { };

    extensions = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    config = mkOption {
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {lib, ... }: mkIf cfg.enable {
      programs.vscode = {
        enable = true;
        package = cfg.package;
        enableExtensionUpdateCheck = false;

        extensions = mkMerge [
          defaultExtensions
          cfg.extensions
        ];

        userSettings = myLib.recursiveMerge [
          defaultConfig
          cfg.config
        ];
      };

      home = {
        activation = {
          removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
            rm -rf "${configFilePath}"
          '';

          overwriteVSCodeSymlink = let
            userSettings = config.home-manager.users.${username}.programs.vscode.userSettings;
            jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
          in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            rm -rf "${configFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${configFilePath}"
          '';
        };
      };
    };
  };
}
