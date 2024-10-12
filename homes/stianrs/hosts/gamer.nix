_:
{
  modules = {
    development.enable = true;
    kubernetes.enable = true;
    # TODO: See if I can automate this based on the nixos module being enabled on the host
    security._1password.enable = true;
  };
}
