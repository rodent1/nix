{
  rodent.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.plasma;
    in
    {

      options.modules.desktop.plasma = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Plasma home-manager modules";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.fuzzel = {
          enable = true;
        };

        catppuccin.fuzzel.enable = true;

        home.packages = with pkgs; [
          # Apps
          kdePackages.kalk
          kdePackages.dragon
          # Utilities
          ffmpegthumbnailer
        ];
      };
    };
}
