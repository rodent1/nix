{ pkgs, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default
  ];
  config = {
    modules = {
      device = {
        cpu = "intel";
        gpu = "intel";
        hostId = "dca6b0fd";
      };
      users.stianrs = {
        enable = true;
        enableDevTools = true;
        enableKubernetesTools = true;
      };
    };

    # # Use the systemd-boot EFI boot loader.
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    wsl = {
      enable = true;
      defaultUser = "stianrs";
    };
    environment.systemPackages = with pkgs; [
      wslu
    ];
  };
}
