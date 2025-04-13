{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      # FIXME: Switch back to stable once 4.0 is available
      package = pkgs.unstable.fish;
    };
  };
}
