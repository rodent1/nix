{
  flake.modules.nixos.core = {
    # Set your time zone.
    time.timeZone = "Europe/Oslo";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "no";
    };
  };
}
