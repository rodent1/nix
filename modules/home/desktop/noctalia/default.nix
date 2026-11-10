{
  internal.homeModules.desktop =
    { pkgs, ... }:
    {
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
      ];
    };
}
