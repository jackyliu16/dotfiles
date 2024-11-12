{ pkgs, ... }:  {
  xdg.dataFile."fcitx5/rime" = {
    source = "${pkgs.rime-ice-pkgs}/share/rime-data";
    recursive = true;
  };
}
