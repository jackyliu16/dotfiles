{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-frost";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "zendo";
    repo = "rime-frost";
    rev = "${finalAttrs.version}";
    hash = "sha256-r7EEPvmVDWNQbwUwkZght3o7ieGgGg95N+Z48WVbST4=";
  };

  installPhase = ''
    mkdir -p "$out/share/rime-data"
    cp -r cn_dicts      "$out/share/rime-data/cn_dicts"
    cp -r cn_dicts_cell "$out/share/rime-data/cn_dicts_cell"
    cp -r en_dicts      "$out/share/rime-data/en_dicts"
    cp -r opencc        "$out/share/rime-data/opencc"
    cp -r others        "$out/share/rime-data/others"
    cp -r lua           "$out/share/rime-data/lua"

    install -Dm644 *.{schema,dict}.yaml -t "$out/share/rime-data/"
    install -Dm644 *.lua                -t "$out/share/rime-data/"
    install -Dm644 custom_phrase.txt    -t "$out/share/rime-data/"
    install -Dm644 symbols*.yaml        -t "$out/share/rime-data/"
    install -Dm644 weasel.yaml          -t "$out/share/rime-data/"
    install -Dm644 squirrel.yaml        -t "$out/share/rime-data/"
    install -Dm644 default.yaml         -t "$out/share/rime-data/"
  '';

  meta = {
    description = "白霜词库: 基于雾凇拼音重制的，更纯净、词频准确、智能的词库。";
    homepage = "https://github.com/gaboolic/rime-frost";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})

