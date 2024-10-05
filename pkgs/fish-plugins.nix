{ callPackage, buildFishPlugin }:
let
  sourceData = callPackage _sources/generated.nix { };
in
{
  tmux-fish = buildFishPlugin {
    inherit (sourceData.tmux-fish) pname src;
    version = sourceData.tmux-fish.date;
  };
}
