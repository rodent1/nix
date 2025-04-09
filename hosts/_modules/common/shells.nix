{ pkgs, ... }:
{
  environment.shells = with pkgs; [ fish ];

  programs = {
    fish = {
      enable = true;
      # FIXME: Switch back to stable once 4.0 is available
      # package = pkgs.fish;
      package = pkgs.unstable.fish;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
