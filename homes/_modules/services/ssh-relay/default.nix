{
  pkgs,
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.modules.services.ssh-relay;

  socket = "${config.home.homeDirectory}/.ssh/agent.sock";
  npiperelay = pkgs.stdenvNoCC.mkDerivation {
    name = "npiperelay";
    src = pkgs.fetchzip {
      url = "https://github.com/jstarks/npiperelay/releases/download/v0.1.0/npiperelay_windows_amd64.zip";
      hash = "sha256-GcwreB8BXYGNKJihE2xeelsroy+JFqLK1NK7Ycqxw5g=";
      stripRoot = false;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      mv npiperelay.exe $out/bin
    '';
  };
in {
  options.modules.services.ssh-relay = {
    enable = lib.mkEnableOption "ssh-relay";
  };

  config = lib.mkIf (cfg.enable && nixosConfig.wsl.enable) {
    systemd.user.services.ssh-relay = {
      Unit = {
        Description = "1password SSH Relay";
      };

      Service = {
        ExecStart = "${pkgs.writeShellScript "start-relay" ''
          # Ensure all necessary paths are in PATH
          export PATH=/run/current-system/sw/bin:$PATH
          # Explicitly export the environment variable with the full path
          export SSH_AUTH_SOCK=${socket}

          # Set the path to the nix-cache directory
          WINPATH="$(/bin/wslpath "$( (cd /mnt/c/; /mnt/c/Windows/System32/cmd.exe /c 'echo %LOCALAPPDATA%') | ${pkgs.gnused}/bin/sed -e 's/\r//')")/nix-cache"
          # Create the nix-cache directory if it doesn't exist
          if [ ! -d "$WINPATH" ]; then
            echo "Creating nix-cache directory at $WINPATH"
            mkdir -p "$WINPATH"
          fi

          # Copy npiperelay to the nix-cache directory if it doesn't exist or is outdated
          if [ ! -f "$WINPATH/npiperelay.exe" ] || ! cmp -s ${npiperelay}/bin/npiperelay.exe "$WINPATH/npiperelay.exe"; then
            echo "Copying npiperelay to $WINPATH"
            cp ${npiperelay}/bin/npiperelay.exe "$WINPATH/npiperelay.exe"
          fi

          # Check if npiperelay process is already running
          if ! ${pkgs.procps}/bin/pgrep -f "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent" >/dev/null; then
            # Remove existing socket if it exists
            [ -S $SSH_AUTH_SOCK ] && rm -f $SSH_AUTH_SOCK

            # Log starting message
            echo "Starting SSH-Agent relay..."

            # Run socat to relay the socket
            ${pkgs.util-linux}/bin/setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:${socket},fork EXEC:"$WINPATH/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
          fi
        ''}";

        Restart = "always";
        RestartSec = "5";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };

    home.sessionVariables = {
      SSH_AUTH_SOCK = socket;
    };
  };
}
