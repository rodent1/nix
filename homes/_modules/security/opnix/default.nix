{ lib, isWSL, ... }:
{
  config = {
    programs.onepassword-secrets = {
      enable = true;
      tokenFile = "/etc/opnix-token";
      secrets = {
        ageKey = {
          reference = "op://dotfiles/age key/Key";
          path = ".config/age/keys.txt";
          mode = "0600";
        };

        atuinKey = {
          reference = "op://dotfiles/Atuin/key64";
          path = ".config/atuin/key";
          mode = "0600";
        };

        mcConfig = {
          reference = "op://dotfiles/mc-config/config.json";
          path = ".mc/config.json";
          mode = "0600";
        };

        onepassToken = lib.mkIf isWSL {
          reference = "op://dotfiles/1password/OP_SERVICE_ACCOUNT_TOKEN";
          path = ".config/1Password/op-service-account-token";
          mode = "0600";
        };
      };
    };
  };
}
