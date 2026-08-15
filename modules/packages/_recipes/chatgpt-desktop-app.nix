{
  lib,
  stdenv,
  stdenvNoCC,
  callPackage,
  dpkg,
  autoPatchelfHook,
  bubblewrap,
  makeWrapper,
  wrapGAppsHook3,
  writeShellApplication,
  alsa-lib,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  git,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libpulseaudio,
  libsecret,
  libusb1,
  libuuid,
  libva,
  libxkbcommon,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxcb,
  mesa,
  nodejs-slim,
  nspr,
  nss,
  openssh,
  pango,
  pipewire,
  qt6,
  ripgrep,
  systemd,
  tectonic-unwrapped,
  trash-cli,
  vulkan-loader,
  wayland,
  xdg-utils,
}:

let
  sourceData = callPackage ../_sources/generated.nix { };
  launcher = writeShellApplication {
    name = "chatgpt-launcher";

    text = ''
      : "''${CHATGPT_EXECUTABLE:?}"
      : "''${CHATGPT_RESOURCES_SOURCE:?}"
      : "''${CHATGPT_RESOURCES_CACHE_KEY:?}"

      cacheHome="''${XDG_CACHE_HOME:-''${HOME:?XDG_CACHE_HOME and HOME are unset}/.cache}"
      cacheRoot="$cacheHome/chatgpt/bundled-plugins"
      cacheKey="''${CHATGPT_RESOURCES_CACHE_KEY##*/}"
      resourcesPath="$cacheRoot/$cacheKey"

      if [[ ! -f "$resourcesPath/.complete" ]]; then
        mkdir -p "$cacheRoot"
        stagingPath=$(mktemp -d "$cacheRoot/.staging-$cacheKey.XXXXXXXX")
        trap 'rm -rf -- "$stagingPath"' EXIT

        ln -s \
          "$CHATGPT_RESOURCES_SOURCE/"{codex,codex-code-mode-host,cua_node,native,rg} \
          "$stagingPath"
        cp -R "$CHATGPT_RESOURCES_SOURCE/plugins" "$stagingPath/plugins"
        chmod -R u+w "$stagingPath/plugins"
        touch "$stagingPath/.complete"

        if mv -T "$stagingPath" "$resourcesPath" 2>/dev/null; then
          trap - EXIT
        elif [[ -f "$resourcesPath/.complete" ]]; then
          rm -rf -- "$stagingPath"
          trap - EXIT
        else
          echo "Failed to publish ChatGPT's writable bundled-plugin resources" >&2
          exit 1
        fi
      fi

      export CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH="$resourcesPath"

      waylandFlags=()
      if [[ -n "''${NIXOS_OZONE_WL:-}" && -n "''${WAYLAND_DISPLAY:-}" ]]; then
        waylandFlags=(
          --ozone-platform-hint=auto
          --enable-features=WaylandWindowDecorations
          --enable-wayland-ime=true
        )
      fi

      exec "$CHATGPT_EXECUTABLE" "''${waylandFlags[@]}" "$@"
    '';
  };

  externalUrlOpener = writeShellApplication {
    name = "xdg-open";

    # Electron's children inherit the runtime library path required by the
    # unpackaged app. Do not leak it into native applications such as Firefox.
    text = ''
      unset LD_LIBRARY_PATH
      exec ${lib.getExe' xdg-utils "xdg-open"} "$@"
    '';
  };

  runtimeLibs = [
    alsa-lib
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgbm
    libGL
    libnotify
    libpulseaudio
    libsecret
    libusb1
    libuuid
    libva
    libxkbcommon
    mesa
    pipewire
    qt6.qtbase
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    vulkan-loader
    wayland
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxcb
  ];

  runtimeBins = [
    bubblewrap
    git
    glib
    nodejs-slim
    openssh
    trash-cli
    xdg-utils
  ];
in
stdenvNoCC.mkDerivation {
  inherit (sourceData.chatgpt-desktop-app) pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibs;

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;
  dontWrapQtApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile "$src" | tar --extract --file - --no-same-permissions
    runHook postUnpack
  '';

  # autoPatchelf moves PT_INTERP beyond detect-libc's 2 KiB scan. Its
  # process.report fallback trips Electron's CFI, so use the glibc watcher.
  postPatch = ''
    grep -aFq 'const family = familySync();' usr/lib/chatgpt/resources/app.asar
    sed -i "s|const family = familySync();|const family = 'glibc'     ;|" usr/lib/chatgpt/resources/app.asar
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/share"
    cp -a usr/lib/chatgpt "$out/lib/"
    cp -a usr/share/applications usr/share/doc usr/share/pixmaps "$out/share/"

    # The package uses its Qt 6 integration shim, not the Qt 5 fallback.
    rm -f "$out/lib/chatgpt/libqt5_shim.so"

    # Remove native prebuilds for unsupported libc and operating systems.
    rm -f \
      "$out/lib/chatgpt/resources/app.asar.unpacked/node_modules/@worklouder/device-kit-oai/node_modules/@worklouder/wl-device-kit/node_modules/serialport/node_modules/@serialport/bindings-cpp/prebuilds/"{linux-*/node.napi.musl.node,android-*/node.napi.*.node} \
      "$out/lib/chatgpt/resources/app.asar.unpacked/node_modules/@worklouder/device-kit-oai/node_modules/@worklouder/wl-device-kit/node_modules/node-hid/prebuilds/"{HID,HID_hidraw}-linux-*-musl/node-napi-v4.node \
      "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/"{browser,chrome}"/node_modules/classic-level/prebuilds/"{linux-*/classic-level.musl.node,android-*/classic-level.*.node} \
      "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/"{browser,chrome}"/scripts/node_modules/classic-level/prebuilds/"{linux-*/classic-level.musl.node,android-*/classic-level.*.node}

    ln -sf ${lib.getExe tectonic-unwrapped} \
      "$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"
    ln -sf ${lib.getExe ripgrep} "$out/lib/chatgpt/resources/rg"
    ln -sf ${lib.getExe nodejs-slim} "$out/lib/chatgpt/resources/cua_node/bin/node"

    install -Dm755 ${lib.getExe launcher} "$out/bin/chatgpt"

    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail "Exec=chatgpt %U" "Exec=$out/bin/chatgpt %U"

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ externalUrlOpener ]}
      --suffix PATH : ${lib.makeBinPath runtimeBins}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
    )
  '';

  postFixup = ''
    wrapProgram "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --set CHATGPT_EXECUTABLE "$out/lib/chatgpt/ChatGPT" \
      --set CHATGPT_RESOURCES_SOURCE "$out/lib/chatgpt/resources" \
      --set CHATGPT_RESOURCES_CACHE_KEY "$out" \
      --set-default CODEX_BROWSER_USE_NODE_PATH ${lib.getExe nodejs-slim} \
      --set-default NODE_REPL_NODE_PATH ${lib.getExe nodejs-slim}
  '';

  meta = {
    description = "OpenAI's official ChatGPT desktop app for Linux";
    homepage = "https://developers.openai.com/codex/app";
    changelog = "https://learn.chatgpt.com/docs/changelog";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
