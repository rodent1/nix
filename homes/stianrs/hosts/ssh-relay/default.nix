{
  config,
  lib,
  pkgs,
  ...
}:
let
  socket = "~/.ssh/agent.sock";
  inherit (pkgs) util-linux socat ps;
  grep = pkgs.gnugrep;
in
{
  systemd.user.services.ssh-relay = {
    # TODO: This doesn't really work yet, I have to bootstrap agent.sock by running the generated script manually
    Unit = {
      Description = "1password SSH Relay";
    };

    Service = {
      Type = "oneshot";

      ExecStart = "${pkgs.writeShellScript "start-relay" ''
        # Make sure that basic commands are available
        PATH=$PATH:/run/current-system/sw/bin/

        # Configure ssh forwarding
        SSH_AUTH_SOCK=${socket}

        # need `ps -ww` to get non-truncated command for matching
        # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
        ALREADY_RUNNING=$(${ps}/bin/ps -auxww | ${grep}/bin/grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
        if [[ $ALREADY_RUNNING != "0" ]]; then
            if [[ -S $SSH_AUTH_SOCK ]]; then
                # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
                echo "removing previous socket..."
                rm $SSH_AUTH_SOCK
            fi
            echo "Starting SSH-Agent relay..."
            # setsid to force new session to keep running
            # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
            (${util-linux}/bin/setsid ${socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
        fi
      ''}";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  programs.fish.shellInit = ''
    set -gx SSH_AUTH_SOCK ${socket}
  '';
}
