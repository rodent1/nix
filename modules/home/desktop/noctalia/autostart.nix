{
  internal.homeModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktop.noctalia;
    in
    {
      config = lib.mkIf (config.modules.desktop.enable && cfg.enable && !config.host.isWSL) {
        xdg.autostart.enable = true;
        xdg.autostart.entries = [
          "${pkgs._1password-gui}/share/applications/1password.desktop"
          "${pkgs.vesktop}/share/applications/vesktop.desktop"
        ];

        systemd.user.services.xembed-sni-proxy = {
          Unit.Before = [ "xdg-desktop-autostart.target" ];

          # Unlike WantedBy, this prevents the autostart target from succeeding
          # when the readiness chain fails.
          Install.RequiredBy = [ "xdg-desktop-autostart.target" ];

          Service = {
            ExecStartPre = pkgs.writeShellScript "wait-for-status-notifier-watcher" ''
              for attempt in {1..100}; do
                watcher="$(
                  ${pkgs.systemd}/bin/busctl --user get-property \
                    org.kde.StatusNotifierWatcher \
                    /StatusNotifierWatcher \
                    org.kde.StatusNotifierWatcher \
                    IsStatusNotifierHostRegistered \
                    2>/dev/null
                )"

                if [ "$watcher" = "b true" ]; then
                  exit 0
                fi

                ${pkgs.coreutils}/bin/sleep 0.1
              done

              echo "No StatusNotifier host became ready within 10 seconds" >&2
              exit 1
            '';

            ExecStartPost = pkgs.writeShellScript "wait-for-xembed-sni-proxy" ''
              for attempt in {1..50}; do
                if ${pkgs.xwininfo}/bin/xwininfo \
                  -name "Qt Selection Owner for xembedsniproxy" \
                  >/dev/null 2>&1
                then
                  exit 0
                fi

                ${pkgs.coreutils}/bin/sleep 0.1
              done

              echo "xembed-sni-proxy did not become ready within 5 seconds" >&2
              exit 1
            '';
          };
        };
      };
    };
}
