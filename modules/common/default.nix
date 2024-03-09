{ hostName, pkgs, ... }:
{
  imports = [
    ./device.nix

    ./users
    ./users/stianrs
  ];

  networking.hostName = hostName;

  time.timeZone = "Europe/Oslo";

  nix = {
    settings = {
      accept-flake-config = true;
      builders-use-substitutes = true;
      cores = 0;
      experimental-features = [ "nix-command" "flakes" ];
      max-jobs = "auto";
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      # Delete older generations too
      options = "--delete-older-than 2d";
    };
  };

  environment.systemPackages = with pkgs; [
    gnused
    gnugrep
  ];
}
