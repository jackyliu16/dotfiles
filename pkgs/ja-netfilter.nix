{ pkgs
, stdenvNoCC
, fetchFromGitHub 
, ...
}: stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ja-netfilter";
  version = "240701";

  src = pkgs.fetchFromGitHub {
    owner = "LostAttractor";
    repo = "jetbra";
    rev = "94585581c360862eab1843bf7edd8082fdf22542";
    sha256 = "sha256-9jeiF9QS4MCogIowu43l7Bqf7dhs40+7KKZML/k1oWo=";
  };

  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp ja-netfilter.jar $out
    cp -r config-jetbrains $out
    cp -r plugins-jetbrains $out

    runHook postInstall
  '';


  meta = {
    description = "Jetbrains IDEs crack";
    homepage = "https://3.jetbra.in";
  };
})
