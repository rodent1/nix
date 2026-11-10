# Turns on opnix and names its bootstrap token. Each secret is declared by the
# module that reads it.
{
  internal.homeModules.default =
    { config, ... }:
    {
      config = {
        programs.onepassword-secrets = {
          enable = true;
          tokenFile = "${config.home.homeDirectory}/.config/opnix/token";
        };
      };
    };
}
