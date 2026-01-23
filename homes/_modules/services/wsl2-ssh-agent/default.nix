{
  pkgs,
  ...
}:
{
  config = {
    systemd.user.services.wsl2-ssh-agent = {
      Unit = {
        Description = "WSL2 SSH Agent Bridge";
      };

      Service = {
        ExecStart = "${pkgs.wsl2-ssh-agent}/bin/wsl2-ssh-agent --verbose --foreground --socket=%t/wsl2-ssh-agent.sock";
        Restart = "on-failure";
        RestartSec = "10";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock";
    };
  };
}
