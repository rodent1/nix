{
  callPackage,
  lib,
  pkgs,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
{
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    inherit (sourceData.catppuccin) src;
    pluginName = sourceData.catppuccin.pname;
    version = lib.strings.removePrefix "v" sourceData.catppuccin.version;
  };
}
