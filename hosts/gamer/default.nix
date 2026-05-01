_: {
  imports = [ ./hardware-configuration.nix ];

  config = {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;
        powerManagement.enable = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    # https://niri-wm.github.io/niri/Nvidia.html#high-vram-usage-fix
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
      ''
        {
            "rules": [
                {
                    "pattern": {
                        "feature": "procname",
                        "matches": "niri"
                    },
                    "profile": "Limit Free Buffer Pool On Wayland Compositors"
                }
            ],
            "profiles": [
                {
                    "name": "Limit Free Buffer Pool On Wayland Compositors",
                    "settings": [
                        {
                            "key": "GLVidHeapReuseRatio",
                            "value": 0
                        }
                    ]
                }
            ]
        }
      '';

    modules = {
      desktop.enable = true;
      games.enable = true;
    };
  };
}
