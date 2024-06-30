{
  stdenv,
  lib,
  fetchurl,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  systemToPlatform = {
    "x86_64-linux" = {
      name = "linux-amd64";
      hash = "sha256-n290Rld+opMXAQpBbT/DZ0Y8I2i0lkiH6nBspwThSok=";
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = "sha256-AHLOgfVNVYbSesYP34kSZ9mktESyppFr83THhdzBCos=";
    };
    "x86_64-darwin" = {
      name = "darwin-amd64";
      hash = "sha256-o6wb6UmGzPbvzXJ+N43NFboJBYt3cOXtcSBEFOSoXfI=";
    };
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-kuJTKST7PFQ+QmldKOmfy1awFj6dQH9zlKvpob8FdfQ=";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "gh-copilot";
  version = "1.0.3";

  src = fetchurl {
    name = "gh-copilot";
    url = "https://github.com/github/gh-copilot/releases/download/v${version}/${platform.name}";
    hash = "${platform.hash}";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/bin/gh-copilot

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ask for assistance right in your terminal";
    homepage = "https://github.com/github/gh-copilot";
    license = licenses.unfree;
    maintainers = with maintainers; [ rodent1 ];
    mainProgram = "gh-copilot";
    platforms = platforms.all;
  };
}
