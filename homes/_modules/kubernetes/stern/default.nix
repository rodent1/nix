{ pkgs, lib, config, ... }:
let cfg = config.modules.kubernetes;
in {
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.unstable.stern ];
      programs.fish = {
        interactiveShellInit = ''
          ${pkgs.unstable.stern}/bin/stern --completion fish | source
        '';
      };
    })
  ];
}
