{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-rime
      # (fcitx5-rime.override {
      #   rimeDataPkgs =
      #     [
      #       pkgs.rime-data
      #       pkgs.nur.repos.xddxdd.rime-ice
      #     ];
      # })
      # # fcitx5-moegirl NOTE: Stewart86/flakes
      # fcitx5-chinese-addons
      # fcitx5-table-extra
      # # colorscheme
      # fcitx5-nord
      # fcitx5-rose-pine
    ];
  };

  # xdg.dataFile."fcitx5/rime" = {
  #   source = "${pkgs.rime-ice-pkgs}/share/rime-data";
  #   recursive = true;
  # };
}
