{
  pkgs,
  lib,
  config,
  hostname,
  ...
}:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [ ./hardware-configuration.nix ];

  config = {
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking = {
      hostName = hostname;
      networkmanager.enable = true;
    };

    # Set your time zone.
    time.timeZone = "Europe/Oslo";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "no";
      variant = "nodeadkeys";
    };

    # Configure console keymap
    console.keyMap = "no";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    users.users.stianrs = {
      uid = 1000;
      name = "stianrs";
      home = "/home/stianrs";
      group = "stianrs";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
        builtins.readFile ../../homes/stianrs/config/ssh/ssh.pub
      );
      isNormalUser = true;
      hashedPasswordFile = config.services.onepassword-secrets.secretPaths.hashedPassword;
      description = "Stian Rossavik Sporaland";
      extraGroups = [
        "wheel"
        "users"
      ]
      ++ ifGroupsExist [
        "network"
        "networkmanager"
        "samba-users"
        "docker"
      ];

      packages = with pkgs; [
        discord
        firefox
        ghostty
        unstable.vscode
      ];
    };
    users.groups.stianrs = {
      gid = 1000;
    };

    modules = {
      services._1password.enable = true;
      services.podman.enable = true;
      services.tailscale.enable = false;
      system.openssh.enable = true;
    };
  };
}
