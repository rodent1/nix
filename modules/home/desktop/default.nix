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
          readOnly = true;
          description = "Desktop session selection supplied by the NixOS desktop module";
        };
      };

      config = lib.mkIf cfg.enable {
        home.file.".face".source = ./_assets/profile.jpg;
        home.packages = with pkgs; [
          ffmpegthumbnailer
          unstable.waytator
        ];
      };
    };
}
