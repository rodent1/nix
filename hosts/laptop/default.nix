{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: {
  imports = [
    ../common/optional/fish.nix
    ../common/optional/vscode-server.nix
    ../common/optional/wsl.nix
    ./configuration.nix
  ];

  networking.hostName = "laptop";

  time.timeZone = lib.mkDefault "Europe/Oslo";

  users.users.stianrs = {
    description = "Stian R. Sporaland";
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      stianrs = import ../../home-manager/home.nix;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
