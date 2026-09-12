{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      options.modules.desktop.noctalia.enable = lib.mkEnableOption "Noctalia home configuration";

      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        programs.noctalia = {
          enable = true;
          systemd.enable = false;
        };

        services = {
          cliphist.enable = true;
          gnome-keyring.enable = true;
          xembed-sni-proxy.enable = true;
        };

        home.pointerCursor = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };

        gtk.enable = true;

        home.packages = with pkgs; [
          file-roller
          gnome-calculator
          gnome-text-editor
          nautilus
          loupe
          showtime
          waytator
        ];
      };
    };
}
