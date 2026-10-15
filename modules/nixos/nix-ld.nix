{
  internal.nixosModules.default =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;

        # Libraries needed by T3Code's browser
        libraries = with pkgs; [
          alsa-lib
          at-spi2-core
          dbus
          expat
          glib
          libgbm
          libx11
          libxcb
          libxcomposite
          libxdamage
          libxext
          libxfixes
          libxkbcommon
          libxrandr
          nspr
          nss
          systemd
        ];
      };
    };
}
