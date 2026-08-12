{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  patchelf,
  binutils,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  graphite2,
  gtk3,
  libGL,
  libdrm,
  libgbm,
  libnotify,
  libusb1,
  libxcb,
  libxkbcommon,
  nspr,
  nss,
  openssl,
  pango,
  pipewire,
  qt5,
  qt6,
  systemd,
  tectonic-unwrapped,
  wayland,
  xdg-utils,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
}:
stdenv.mkDerivation {
  pname = "chatgpt-desktop";
  version = "26.803.81509";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    hash = "sha256-qb+Ro2j598Tuo4CCqfuPtGuNAFtxmm13FdLloZgsOOs=";
  };

  nativeBuildInputs = [
    binutils
    dpkg
    makeWrapper
    patchelf
  ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase =
    let
      runtimeLibraries = [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        graphite2
        gtk3
        libGL
        libdrm
        libgbm
        libnotify
        libusb1
        libxcb
        libxkbcommon
        nspr
        nss
        openssl
        pango
        pipewire
        qt5.qtbase
        qt6.qtbase
        stdenv.cc.cc
        systemd
        wayland
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
      ];
      runtimeLibraryPath = lib.makeLibraryPath runtimeLibraries;
    in
    ''
      runHook preInstall

      dpkg --fsys-tarfile "$src" | tar --extract

      mkdir -p "$out/lib" "$out/share"
      cp -a usr/lib/chatgpt "$out/lib/chatgpt"
      cp -a usr/share/applications usr/share/pixmaps "$out/share/"
      chmod -R g-w "$out"

      rm "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"
      ln -s "${tectonic-unwrapped}/bin/tectonic" \
        "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"

      while IFS= read -r -d $'\0' file; do
        if readelf -h "$file" 2>/dev/null | grep -q 'Machine:.*Advanced Micro Devices X86-64' \
          && readelf -d "$file" 2>/dev/null | grep -q '(NEEDED)' \
          && ! readelf -d "$file" 2>/dev/null | grep -q 'libc\.musl'; then
          file_rpath="${runtimeLibraryPath}:$out/lib/chatgpt:$out/lib/chatgpt/resources/cua_node/lib/node_modules/@img/sharp-libvips-linux-x64/lib:$(dirname "$file")"
          if ! patchelf --set-rpath "$file_rpath" "$file"; then
            echo "failed to patch RPATH for $file" >&2
            exit 1
          fi
          if interpreter="$(patchelf --print-interpreter "$file" 2>/dev/null)" && [ -n "$interpreter" ]; then
            patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$file"
          fi
        fi
      done < <(find "$out/lib/chatgpt" -type f -print0)

      substituteInPlace "$out/share/applications/chatgpt.desktop" \
        --replace-fail 'Exec=chatgpt %U' "Exec=$out/bin/chatgpt %U"

      makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
        --set-default ALSA_PLUGIN_DIR "${pipewire}/lib/alsa-lib" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"

      runHook postInstall
    '';

  buildInputs = [ gtk3 ];

  meta = {
    description = "Official ChatGPT desktop application for Linux";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
