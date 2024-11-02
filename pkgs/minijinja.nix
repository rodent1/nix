{
  lib,
  rustPlatform,
  pkgs,
}:
let
  sourceData = pkgs.callPackage ./_sources/generated.nix { };
  packageData = sourceData.minijinja;
in
rustPlatform.buildRustPackage {
  inherit (packageData) pname src version;

  cargoSha256 = "sha256-2aeRb5jNZbpzAgpne494BMr7rkDqZUJEpITtHbdmhxY=";

  # https://github.com/mitsuhiko/minijinja/issues/402
  doCheck = false;

  cargoBuildFlags = "--bin minijinja-cli";

  meta = with lib; {
    description = "Command Line Utility to render MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ psibi ];
    mainProgram = "minijinja-cli";
  };
}
