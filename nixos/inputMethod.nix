{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      waylandFrontend = false;
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
        fcitx5-chinese-addons

        # ColorScheme
        fcitx5-nord
        fcitx5-rose-pine
      ];
    };
  };
}
