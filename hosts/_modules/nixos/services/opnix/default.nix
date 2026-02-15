{ ... }:

{
  # Enable OpNix with SSL certificate management
  services.onepassword-secrets = {
    enable = true;
    tokenFile = "/etc/opnix-token";
    # Ensure user has access to onepassword-secrets group
    users = [ "stianrs" ];

    secrets = {
      hashedPassword = {
        reference = "op://dotfiles/stianrsPassword/hashedPassword";
        owner = "root";
        group = "root";
        mode = "0600";
      };
    };
  };
}
