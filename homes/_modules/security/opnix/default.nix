{ ... }:
{
  config = {
    programs.onepassword-secrets = {
      enable = true;
      tokenFile = "/etc/opnix-token";
      secrets = {
        atuinKey = {
          reference = "op://dotfiles/Atuin/key";
          mode = "0600";
        };
      };
    };
  };
}
