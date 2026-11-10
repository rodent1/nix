{
  internal.homeModules.stianrs =
    _:
    let
      git_name = "Stian R. Sporaland";
      git_email = "mail@stian.rs";
      git_signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBACoz3DyvP3a6ujHA2MLlzKKlW9VAJ2V8+fa9mMzC0x";
    in
    {
      modules = {
        security = {
          ssh = {
            enable = true;
            settings = {
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

        shell = {
          atuin.enable = true;

          fish.enable = true;

          git = {
            enable = true;
            name = git_name;
            email = git_email;
            signingKey = git_signingKey;
          };

          mise.enable = true;
          nix-your-shell.enable = true;
          nvim.enable = true;

          starship.enable = true;
          tmux.enable = true;
        };

        themes = {
          catppuccin = {
            enable = true;
            flavor = "mocha";
          };
        };
      };
    };
}
