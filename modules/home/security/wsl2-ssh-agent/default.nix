{
  internal.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      healthCheck = pkgs.writeShellScript "wsl2-ssh-agent-health-check" ''
        ${pkgs.coreutils}/bin/timeout --kill-after=5s 15s \
          ${pkgs.openssh}/bin/ssh-add -l >/dev/null 2>&1
        status=$?

        # ssh-add returns 1 when the agent has no identities, which still means
        # that the bridge answered successfully. Any other failure indicates a
        # broken connection or a timed-out request.
        if [ "$status" -gt 1 ]; then
          echo "wsl2-ssh-agent health check failed with status $status; restarting" >&2
          ${pkgs.systemd}/bin/systemctl --user --no-block restart wsl2-ssh-agent.service
        fi
      '';
    in
    {
      config = lib.mkIf config.host.isWSL {
        systemd.user.services.wsl2-ssh-agent = {
          Unit = {
            Description = "WSL2 SSH Agent Bridge";
          };

          Service = {
            ExecStart = "${pkgs.wsl2-ssh-agent}/bin/wsl2-ssh-agent --verbose --foreground --socket=%t/wsl2-ssh-agent.sock";
            Restart = "on-failure";
            RestartSec = "10";
            TimeoutStopSec = "10s";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        systemd.user.services.wsl2-ssh-agent-health-check = {
          Unit = {
            Description = "Check the WSL2 SSH Agent Bridge";
            After = [ "wsl2-ssh-agent.service" ];
          };

          Service = {
            Type = "oneshot";
            ExecStart = healthCheck;
            Environment = "SSH_AUTH_SOCK=%t/wsl2-ssh-agent.sock";
          };
        };

        systemd.user.timers.wsl2-ssh-agent-health-check = {
          Unit.Description = "Periodically check the WSL2 SSH Agent Bridge";

          Timer = {
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
            Unit = "wsl2-ssh-agent-health-check.service";
          };

          Install.WantedBy = [ "timers.target" ];
        };

        home.sessionVariables = {
          SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock";
        };
      };
    };
}
