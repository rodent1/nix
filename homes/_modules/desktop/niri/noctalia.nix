{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.noctalia;
in
{
  options.modules.desktop.noctalia = {
    enable = lib.mkEnableOption "noctalia shell";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;

      settings = {
        bar = {
          density = "compact";
          position = "top";
          barType = "simple";
          showCapsule = true;
          widgets = {
            left = [
              {
                id = "Launcher";
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm";
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "ActiveWindow";
              }
              {
                id = "MediaMini";
              }
            ];
            center = [
              {
                id = "Workspace";
                hideUnoccupied = false;
                labelMode = "index+name";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Battery";
                displayMode = "icon-always";
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "Network";
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };

        brightness = {
          brightnessStep = 5;
          enforceMinimum = true;
        };

        colorSchemes = {
          predefinedScheme = "Catppuccin";
          schedulingMode = "location";
        };

        general = {
          avatarImage = "/home/${config.home.username}/.face";
        };

        idle = {
          enabled = true;
          screenOffTimeout = 300;
          lockTimeout = 330;
          suspendTimeout = 1800;
          fadeDuration = 5;
        };

        location = {
          name = "Forsand, Sandnes, Norway";
        };
      };
    };
  };
}
