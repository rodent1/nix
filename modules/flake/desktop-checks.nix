{ config, lib, ... }:
let
  hosts = config.flake.nixosConfigurations;

  sessionMatches =
    enabled: host:
    let
      system = host.config;
      home = system.home-manager.users.stianrs;
    in
    builtins.all (value: value == enabled) [
      system.programs.hyprland.enable
      system.programs.hyprland.withUWSM
      system.programs.noctalia.enable
      system.services.displayManager.noctalia-greeter.enable
      home.modules.desktop.enable
      home.wayland.windowManager.hyprland.enable
      home.programs.noctalia.enable
      home.services.xembed-sni-proxy.enable
      (home.xdg.configFile ? "uwsm/env")
    ];

  headlessGamer = hosts.gamer.extendModules {
    modules = [ { modules.desktop.enable = lib.mkForce false; } ];
  };
  desktopWork = hosts.work.extendModules {
    modules = [ { modules.desktop.enable = true; } ];
  };
  mismatchedHome = hosts.gamer.extendModules {
    modules = [
      { home-manager.users.stianrs.modules.desktop.enable = lib.mkForce false; }
    ];
  };
in
{
  perSystem = { pkgs, ... }: {
    checks.desktop =
      assert lib.assertMsg (sessionMatches true hosts.gamer) "gamer desktop session is incomplete";
      assert lib.assertMsg (sessionMatches true hosts.laptop) "laptop desktop session is incomplete";
      assert lib.assertMsg (sessionMatches false hosts.work)
        "work unexpectedly enables a desktop session";
      assert lib.assertMsg (sessionMatches false headlessGamer)
        "disabling the desktop leaves session configuration enabled";
      assert lib.assertMsg (
        !(builtins.tryEval mismatchedHome.config.home-manager.users.stianrs.modules.desktop.enable).success
      ) "Home Manager must not override the system desktop selection";
      assert lib.assertMsg (builtins.any (
        entry: !entry.assertion && entry.message == "modules.desktop.enable is not supported on WSL hosts."
      ) desktopWork.config.assertions) "desktop enablement on WSL must be rejected";
      pkgs.runCommand "desktop-configuration-check" { } "touch $out";
  };
}
