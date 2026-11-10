{
  internal.homeModules.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        programs.onepassword-secrets.secrets.atuinKey = {
          reference = "op://dotfiles/Atuin/key64";
          path = ".config/atuin/key";
          mode = "0600";
        };

        programs.atuin = {
          enable = true;
          package = pkgs.unstable.atuin;
          flags = [ "--disable-up-arrow" ];

          settings = {
            sync_address = "https://sh.rodent.cc";
            key_path = config.programs.onepassword-secrets.secretPaths.atuinKey;
            style = "auto";
            sync.records = true;
            sync_frequency = "0";
          };
        };

        catppuccin.atuin.enable = true;
      };
    };
}
