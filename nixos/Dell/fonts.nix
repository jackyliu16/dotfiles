{ pkgs
, lib
, ... 
}:
{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LD_ADDRESS="zh_CN.UTF-8";
      LD_IDENTIFICATION="zh_CN.UTF-8";
      LD_MEASUREMENT="zh_CN.UTF-8";
      LD_MONETARY="zh_CN.UTF-8";
      LD_NAME="zh_CN.UTF-8";
      LD_NUMERIC="zh_CN.UTF-8";
      LD_PAPER="zh_CN.UTF-8";
      LD_TELEPHONE="zh_CN.UTF-8";
      LD_TIME="zh_CN.UTF-8";
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      # sarasa-gothic
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };

  # fontconfig = {
  #   defaultFonts = {
  #     emoji = [ "Noto Color Emoji" ];
  #     monospace = [
  #       "Noto Sans Mono CJK SC"
  #       "Sarasa Mono SC"
  #       "DejaVu Sans Mono"
  #     ];
  #     sansSerif = [
  #       "Noto Sans CJK SC"
  #       "Source Han Sans SC"
  #       "DejaVu Sans"
  #     ];
  #     serif = [
  #       "Noto Serif CJK SC"
  #       "Source Han Serif SC"
  #       "DejaVu Serif"
  #     ];
  #   };
  # };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-gtk
    ];
  };
}
