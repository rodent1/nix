{ config, ... }:
{
  config = {
    programs.onepassword-secrets = {
      enable = true;
      tokenFile = "/etc/opnix-token";
      secrets = {
        atuinKey = {
          reference = "op://dotfiles/Atuin/key64";
          path = "${config.home.homeDirectory}/.config/atuin/key";
          mode = "0600";
        };
      };
    };
  };
}
