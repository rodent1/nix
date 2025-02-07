{ config, ... }:
let
  ageKeyFile = "${config.xdg.configHome}/age/keys.txt";
  inherit (config.home) homeDirectory;
in
{
  config = {
    sops = {
      defaultSopsFile = ./secrets.sops.yaml;
      age.keyFile = ageKeyFile;
      age.generateKey = true;

      secrets = {
        atuin_key = {
          path = "${config.xdg.configHome}/atuin/key";
        };
        mc_config = {
          path = "${homeDirectory}/.mc/config.json";
        };
        op_service_account_token = {
          path = "${config.xdg.configHome}/op/token";
        };
      };
    };

    home.sessionVariables = {
      SOPS_AGE_KEY_FILE = ageKeyFile;
    };
  };
}
