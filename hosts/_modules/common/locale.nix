{
  lib,
  ...
}: {
  time.timeZone = lib.mkDefault "Europe/Oslo";
  environment .variables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
