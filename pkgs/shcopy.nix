{
  buildGoModule,
  callPackage,
  lib,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
buildGoModule rec {
  inherit (sourceData.shcopy) pname src;
  version = lib.strings.removePrefix "v" sourceData.shcopy.version;

  vendorHash = "sha256-kD73EozkeUd23pwuy71bcNmth2lEKom0CUPDUNPNB1Q=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.ProjectName=${pname}"
    "-X=main.CommitSHA=${src.rev}"
  ];

  meta = with lib; {
    description = "Copy text to your system clipboard locally and remotely using ANSI OSC52 sequence";
    homepage = "https://github.com/aymanbagabas/shcopy";
    license = licenses.mit;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "shcopy";
  };
}
