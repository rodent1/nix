{
  internal.homeModules.default =
    { config, ... }:
    {
      config = {
        programs.onepassword-secrets = {
          enable = true;
          tokenFile = "${config.home.homeDirectory}/.config/opnix/token";
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
          };
        };
      };
    };
}
