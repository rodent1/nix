{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Oslo";
  environment.variables = {LANG = lib.mkDefault "en_US.UTF-8";};
}
