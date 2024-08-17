{
  buildGoModule,
  callPackage,
  lib,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
buildGoModule rec {
  inherit (sourceData.kubecolor) pname src;
  version = lib.strings.removePrefix "v" sourceData.kubecolor.version;

  vendorHash = "sha256-DLj7ztOFNmDru1sO+ezecQeRbIbOq49M4EcJuWLNstI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Colorizes kubectl output";
    homepage = "https://github.com/hidetatz/kubecolor";
    license = licenses.mit;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "kubecolor";
  };
}
