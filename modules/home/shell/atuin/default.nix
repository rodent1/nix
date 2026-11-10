{
  internal.homeModules.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        programs.atuin = {
          enable = true;
          package = pkgs.unstable.atuin;
          flags = [ "--disable-up-arrow" ];

          settings = {
            sync_address = "https://sh.rodent.cc";
            key_path = "${config.xdg.configHome}/atuin/key";
            style = "auto";
            sync.records = true;
            sync_frequency = "0";
          };
        };

        catppuccin.atuin.enable = true;
      };
    };
}
