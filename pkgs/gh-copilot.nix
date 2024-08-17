{
  stdenv,
  lib,
  callPackage,
}:
let
  inherit (stdenv.hostPlatform) system;
  sourceData = callPackage _sources/generated.nix { };
  throwSystem = throw "Unsupported system: ${system}";

  systemToPlatform = {
    "x86_64-linux" = {
      platformName = "gh-copilot-linux-amd64";
    };
    "aarch64-linux" = {
      platformName = "gh-copilot-linux-arm64";
    };
    "x86_64-darwin" = {
      platformName = "gh-copilot-darwin-amd64";
    };
    "aarch64-darwin" = {
      platformName = "gh-copilot-darwin-arm64";
    };
  };
  platform = systemToPlatform.${system} or throwSystem;
in
stdenv.mkDerivation {
  inherit (sourceData.${platform.platformName}) src;
  version = lib.strings.removePrefix "v" sourceData.${platform.platformName}.version;
  pname = "gh-copilot";

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
