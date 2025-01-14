# Ref On: https://github.com/Duter2016/Duter2016.github.io/blob/2885470d018e534ac1cf06dc037a814195ddcf66/_posts/2023-06-06-ThinkPad%20%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%20Arch%20Linux%E8%AE%B0%E5%BD%95.md?plain=1#L2653-L2666
{ pkgs, ... }: let 
  masterCrackPackages = pkgs.stdenv.mkDerivation rec {
        pname = "masterpdfeditor";
        version = "5.9.82";

        src = pkgs.fetchurl {
          url = "https://code-industry.net/public/master-pdf-editor-${version}-qt5.x86_64.tar.gz";
          hash = "sha256-CbrhhQJ0iiXz8hUJEi+/xb2ZGbunuPuIIgmCRgJhNVU=";
        };

        crack_src = pkgs.fetchurl {
          url = "https://s3download.krakenfiles.com/force-download/YzA2ZGZlM2Y5NzdhYTA2MjKctfI60IOQr1rQBo6XAJbNw-HsvOWxw7Q1Hr3MfbRV/eVlESIlo7a";
          hash = "sha256-aAqH0cQDl6BnEFX1UGbvRR+doLhQqrFT62JhML0iEgU=";
          name = "MasterPDFEditor5.9.10Linux64.7z";
        };

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          libsForQt5.wrapQtAppsHook
        ];

        buildInputs = with pkgs; [
          p7zip
          nss
          libsForQt5.qtbase
          libsForQt5.qtsvg
          sane-backends
          stdenv.cc.cc
          pkcs11helper
        ];

        dontStrip = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/crack_directory
          7z x ${crack_src} -o$out/crack_directory

          p=$out/opt/masterpdfeditor
          mkdir -p $out/bin

          substituteInPlace masterpdfeditor5.desktop \
            --replace-fail 'Exec=/opt/master-pdf-editor-5' "Exec=$out/bin" \
            --replace-fail 'Path=/opt/master-pdf-editor-5' "Path=$out/bin" \
            --replace-fail 'Icon=/opt/master-pdf-editor-5' "Icon=$out/share/pixmaps"

          install -Dm644 -t $out/share/pixmaps      masterpdfeditor5.png
          install -Dm644 -t $out/share/applications masterpdfeditor5.desktop
          install -Dm755 -t $p                      masterpdfeditor5
          install -Dm644 license_en.txt $out/share/$name/LICENSE
          ln -s $p/masterpdfeditor5 $out/bin/masterpdfeditor5
          cp -v -r stamps templates lang fonts $p

          cp $out/crack_directory/crack/masterpdfeditor5 $out/bin

          runHook postInstall
        '';
      };
in {
  networking.extraHosts = ''
    127.0.0.1 reg.code-industry.net 
  '';

  environment.systemPackages = [
    masterCrackPackages
  ];
}
