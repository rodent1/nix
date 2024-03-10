{ pkgs, ... }:

{
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

      system.wsl.enable = true;
      system.vscode-server.enable = true;
    };

    # # Use the systemd-boot EFI boot loader.
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;
  };
}
