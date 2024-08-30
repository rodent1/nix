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
      home.packages = [
        (pkgs.kubectl.withKrewPlugins (
          plugins: with plugins; [
            node-shell
            cnpg
            rook-ceph
          ]
        ))
      ];

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
