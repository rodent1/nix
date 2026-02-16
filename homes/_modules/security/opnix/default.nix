{ config, ... }:
{
  config = {
    programs.onepassword-secrets = {
      enable = true;
      tokenFile = "/etc/opnix-token";
      secrets = {
        ageKey = {
          reference = "op://dotfiles/age key/Key";
          path = "${config.xdg.configHome}/age/keys.txt";
          mode = "0600";
        };

        atuinKey = {
          reference = "op://dotfiles/Atuin/key64";
          path = "${config.xdg.configHome}/atuin/key";
          mode = "0600";
        };

        mcConfig = {
          reference = "op://dotfiles/mc-config/config.json";
          path = "${config.home.homeDirectory}/.mc/config.json";
          mode = "0600";
        };

        onepassToken = {
          reference = "op://dotfiles/1password/OP_SERVICE_ACCOUNT_TOKEN";
          path = "${config.xdg.configHome}/1Password/op-service-account-token";
          mode = "0600";
        };
      };
    };
  };
}
  