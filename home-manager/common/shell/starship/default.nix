{ ... }:

{
  programs.starship = {
    enable = true;
    settings = import ./defaultConfig.nix;
  };
}
