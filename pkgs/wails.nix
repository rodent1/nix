{
  lib,
  buildGoModule,
  callPackage,
  pkg-config,
  makeWrapper,
  go,
  gcc,
  nodejs,
  zlib,
  # Linux specific dependencies
  gtk3,
  webkitgtk_4_1,
}:
let
  sourceData = callPackage _sources/generated.nix { };
in
buildGoModule rec {
  pname = "wails3";
  inherit (sourceData.wails) version src;

  sourceRoot = "${src.name}/v3";

  vendorHash = "sha256-U15ZtN6i3UGv0rd0bAbeBWFO88C2OUjjbmES45Gh/Qo=";

  proxyVendor = true;

  subPackages = [ "cmd/wails3" ];

  # These packages are needed to build wails
  # and will also need to be used when building a wails app.
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Wails apps are built with Go, so we need to be able to
  # add it in propagatedBuildInputs.
  allowGoReference = true;

  # Following packages are required when wails used as a builder.
  propagatedBuildInputs = [
    pkg-config
    go
    gcc
    gtk3
    webkitgtk_4_1
    nodejs
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # As Wails calls a compiler, certain apps and libraries need to be made available.
  postFixup = ''
    wrapProgram $out/bin/wails3 \
      --prefix PATH : ${
        lib.makeBinPath [
          pkg-config
          go
          gcc
          nodejs
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          gtk3
          webkitgtk_4_1
        ]
      } \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH" \
      --set CGO_LDFLAGS "-L${lib.makeLibraryPath [ zlib ]}"
  '';
}
