{ pkgs, config, ... }:
let
  ageKeyFile = "${config.xdg.configHome}/age/keys.txt";
  inherit (config.home) homeDirectory;
in
{
  config = {
    home.packages = [
      pkgs.unstable.sops
      pkgs.age
    ];

    sops = {
      defaultSopsFile = ./secrets.sops.yaml;
      age.keyFile = ageKeyFile;
      secrets = {
        atuin_key = {
          path = "${config.xdg.configHome}/atuin/key";
        };
        mc_config = {
          path = "${homeDirectory}/.mc/config.json";
        };
      };
    };

    home.sessionVariables = {
      SOPS_AGE_KEY_FILE = ageKeyFile;
    };
  };
}
