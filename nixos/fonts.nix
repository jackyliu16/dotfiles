{pkgs, ...}: {
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
      # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
      # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
      noto-fonts # 大部分文字的常见样式，不包含汉字
      noto-fonts-cjk # 汉字部分
      noto-fonts-emoji # 彩色的表情符号字体
      noto-fonts-extra # 提供额外的字重和宽度变种

      # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
      source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
      source-serif # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
      source-han-sans # 思源黑体
      source-han-serif # 思源宋体
      source-code-pro

      open-sans
      liberation_ttf
      wqy_zenhei
      wqy_microhei

      hack-font
      jetbrains-mono
      sarasa-gothic
      julia-mono
      dejavu_fonts

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      # serif = ["Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP" "Noto Color Emoji" "S"];
      # sansSerif = ["Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP" "Noto Color Emoji"];
      sansSerif = [
        "Source Sans 3"
        "Source Han Sans SC"
        "Source Han Sans TC"
        "Source Han Sans HW"
        "Source Han Sans K"
      ];
      serif = [
        "Source Serif 4"
        "Source Han Serif SC"
        "Source Han Serif TC"
        "Source Han Serif HW"
        "Source Han Serif K"
      ];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # TODO: test if kmscon is usefull
  # https://wiki.archlinux.org/title/KMSCON
  # services.kmscon = {
  #   # Use kmscon as the virtual console instead of gettys.
  #   # kmscon is a kms/dri-based userspace virtual terminal implementation.
  #   # It supports a richer feature set than the standard linux console VT,
  #   # including full unicode support, and when the video card supports drm should be much faster.
  #   enable = true;
  #   fonts = [
  #     {
  #       name = "Source Code Pro";
  #       package = pkgs.source-code-pro;
  #     }
  #   ];
  #   extraOptions = "--term xterm-256color";
  #   extraConfig = "font-size=12";
  #   # Whether to use 3D hardware acceleration to render the console.
  #   hwRender = true;
  # };

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

  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-rime
      # fcitx5-moegirl NOTE: Stewart86/flakes
      fcitx5-chinese-addons
      fcitx5-table-extra
      # colorscheme
      fcitx5-nord
      fcitx5-rose-pine
    ];
  };
}

