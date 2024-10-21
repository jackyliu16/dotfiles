{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, autoPatchelfHook
, libsForQt5

, alsa-lib
, libGLU
, libpressureaudio
, freetype
, gst_all_1
, nspr
, nss
, cups
, gdal
, xorg
, wayland
, wayland-scanner
, ... }: 

# let
#   runLibDeps = [
#     curl
#   ];
# in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "ovital";
  version = "2.7.0";

  suffix = {
    aarch64-linux = "aarch64";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://cdn.ovital.com/pub/Linux-${suffix}-OMap-${version}-build2024-07-12.1.deb";
    hash = {
      aarch64-linux = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      x86_64-linux = "sha256-wj7p/YnjlZK2Kp14odFCs8n19kkJTdv1txDKKxSQtl0=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  # https://cdn.ovital.com/pub/Linux-aarch64-OMap-2.7.0-build2024-07-12.1.deb
  # https://cdn.ovital.com/pub/Linux-x86_64-OMap-2.7.0-build2024-07-12.1.deb

  strictDeps = true;

  qtWrapperArgs = [ ''--prefix PATH : $out/opt/plugins'' ];
  QT_DEBUG_PLUGINS = 1;

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    wayland-scanner
    libsForQt5.qtwayland
  ] ++ (with libsForQt5.qt5; [
    wrapQtAppsHook
    qtwayland
    qtx11extras
  ]);

  buildInputs = [
    stdenv.cc.cc.lib

    cups
    nss           # libnss3
    gdal
    nspr          # libnspr4
    alsa-lib
    libGLU
    freetype      # libfreetype
    wayland
    libpressureaudio

    # python312Packages.kaleido
  ] ++ (with libsForQt5; [
    qtbase
    quazip
    qt5.qtwayland
    qt5.qtx11extras
  ]) ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-bad
  ]) ++ (with xorg; [
    libSM         # libsm6
    libxcb        # libx11-xcb1, libxcb1
    libX11        # libx11-6
    libXtst
    libXcursor
    libXdamage
    libXrender    # libxrender1
  ]);
  # Depends: libsm6


  dontConfigure = true;
  dontBuild = true;
  # dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share

    mkdir -p $out/opt
    cp -r opt/com.ovital.map/* $out/opt/
    mkdir -p $out/bin
    ln -s $out/opt/launcher $out/bin/ovital

    runHook postInstall
  '';

    #
    # wrapProgram $out/bin/ovital \
    #   --prefix LD_LIBRARAY_PATH : ${lib.makeLibraryPath runLibDeps} \
    #   --prefix PATH : ${lib.makeBinPath runLibDeps} 
  meta = {
    description = "Ovital Map for Linux Version";
    homepage = "https://www.ovital.com/";
    license = lib.licenses.unfree;
    platform = [ "aarch64-linux" "x86_64-linux" ];
    
    mainPrograms = "ovital";
  };
})
