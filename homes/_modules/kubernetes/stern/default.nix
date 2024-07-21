{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.kubernetes;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.stern ];
      programs.fish.interactiveShellInit = "${pkgs.stern}/bin/stern --completion fish | source";
    })
  ];
}
