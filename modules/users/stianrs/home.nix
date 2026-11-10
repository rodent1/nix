{
  internal.homeModules.stianrs = _: {
    programs = {
      git = {
        signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
        settings.user = {
          name = "Stian R. Sporaland";
          email = "mail@stian.rs";
        };
      };

      ssh.settings = {
        "udm" = {
          User = "root";
          Hostname = "10.1.1.1";
        };
        "tank" = {
          Hostname = "10.1.1.15";
        };
      };
    };
  };
}
