{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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

      config = lib.mkIf (cfg.enable && !config.host.isWSL) {
        home.file.".face".source = ./_assets/profile.jpg;
        home.packages = with pkgs; [
          ffmpegthumbnailer
        ];
      };
    };
}
