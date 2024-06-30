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
      home.packages = [ pkgs.unstable.kubectl ];

      programs.fish.functions = {
        k = {
          description = "kubectl shorthand";
          wraps = "kubectl";
          body = builtins.readFile ./functions/k.fish;
        };
      };
    })
  ];
}
