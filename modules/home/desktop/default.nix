{
  rodent.homeModules.desktop =
    { config, lib, ... }:
    let
      cfg = config.modules.desktop;
    in
    {
      options.modules.desktop = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable desktop home-manager modules";
        };
      };

      config = lib.mkIf (cfg.enable && !config.rodent.isWSL) {
        # profile picture
        home.file.".face".source = ./_assets/profile.jpg;
      };
    };
}
