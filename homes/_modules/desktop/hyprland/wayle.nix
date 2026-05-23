{ pkgs, ... }:
{
  config = {
    services.wayle = {
      enable = true;
      package = pkgs.unstable.wayle;
    };
  };
}
