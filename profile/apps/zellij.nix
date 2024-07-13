# ref on ryan4yin/nix-config
let 
  shellAliases = {
    zj = "zellij";
    zjd = "zellij options --disable-mouse-mode";
  };
in {
  programs.zellij = {
    enable = true;
    settings = {
      theme = "hexadecimal";
      themes.hexadecimal = { # https://zellij.dev/documentation/themes#hexadecimal-color-themes 
        fg = "#D8DEE9";
        bg = "#2E3440";
        black = "#3B4252";
        red = "#BF616A";
        green = "#A3BE8C";
        yellow = "#EBCB8B";
        blue = "#81A1C1";
        magenta = "#B48EAD";
        cyan = "#88C0D0";
        white = "#E5E9F0";
        orange = "#D08770";
      };
      themes.dracula = {
        fg = "248 248 242";
        bg = "40 42 54";
        black = "0 0 0";
        red = "255 85 85";
        green = "80 250 123";
        yellow = "241 250 140";
        blue = "98 114 164";
        magenta = "255 121 198";
        cyan = "139 233 253";
        white = "255 255 255";
        orange = "255 184 108";
      };
    }; 
  };

  # Auto start zellij in nushell
  # programs.nushell.extraConfig = ''
  #   # auto start zellij
  #   # except when in emacs or zellij itself
  #   if (not ("ZELLIJ" in $env)) and (not ("INSIDE_EMACS" in $env)) {
  #     if "ZELLIJ_AUTO_ATTACH" in $env and $env.ZELLIJ_AUTO_ATTACH == "true" {
  #       ^zellij attach -c
  #     } else {
  #       ^zellij
  #     }

  #     # Auto exit the shell session when zellij exit
  #     $env.ZELLIJ_AUTO_EXIT = "false" # disable auto exit
  #     if "ZELLIJ_AUTO_EXIT" in $env and $env.ZELLIJ_AUTO_EXIT == "true" {
  #       exit
  #     }
  #   }
  # '';

  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;
  programs.nushell.shellAliases = shellAliases;

  xdg.configFile."zellij/config.kdl".source = ./config/zellij.kdl;
}
