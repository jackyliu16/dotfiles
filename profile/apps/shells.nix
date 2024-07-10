{ inputs
, outputs
, pkgs
, lib
, config
, specialArgs
, modulesPath
, options
}: 

# ref: https://github.dev/Smaug123/nix-dotfiles
# ref: https://github.com/happysalada/dotfiles/blob/39844591f11d5a98be3deccbb72d1728cc00fb91/homes/programs/nushell.nix#L47

let 
  sessionVariables = {
    EDITOR = "vim";
    LC_ALL = "zh_CN.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
    # RUSTFLAGS = "-L ${pkgs.libiconv}/lib -L ${pkgs.libcxxabi}/lib -L ${pkgs.libcxx}/lib";
    RUST_BACKTRACE = "full";
    http_proxy = "127.0.0.1:7897";
    https_proxy = "127.0.0.1:7897";
  };

  shellAliases = {
    # Personal
    send="curl -F 'c=@-' 'https://fars.ee'";
    blog="cd ~/Documents/blog/";
    arce="cd ~/Coding/arceos-chenlongos/";
    ccfg="cd ~/.config/dotfiles/";
    cref="cd ~/Coding/reference/";
    run="make A=apps/boards/raspi4-net/ PLATFORM=aarch64-raspi4 chainboot";
    nrun = "make A=apps/boards/raspi4-net/ PLATFORM=aarch64-raspi4 chainboot NET=y LOG=trace";
    view = "vim -R";
    nix-upgrade = "sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'";
    connect="ssh pi@192.168.149.1";

    # nix
    nixroots = "nix-store --gc --print-roots";
    nci = "nix_copy_inputs";
    # git
    gp = "git push";
    gpf = "git push --force";
    gl = "git log --pretty=oneline --abbrev-commit";
    gb = "git branch";
    gbd = "git branch --delete --force";
    gc = "git commit --verbose";
    gco = "git checkout";
    gpp = "git pull --prune";
    gsi = "git stash --include-untracked";
    gsp = "git stash pop";
    gsa = "git stage --all";
    gfu = "git fetch upstream";
    gmu = "git merge upstream/master master";
    gu = "git reset --soft HEAD~1";
    grh = "git reset --hard";
    grm = "git rebase master";
    # misc
    b = "broot -ghi";
  };

  # https://github.com/dutchcoders/transfer.sh
  transfer_script = builtins.readFile ./transfer.sh;
in {

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = false;
    useTheme = "atomicBit"; # Offical Themes on: https://ohmyposh.dev/docs/themes
    # useTheme = "1_shell";
    # useTheme = "negligible";
    # useTheme = "nordtron";
    # useTheme = "onehalf.minimal";
    # useTheme = "pararussel";
    # useTheme = "peru";
    # useTheme = "space"; // single line
    # useTheme = "tokyo";
  };

  programs.fish.enable = false;

  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    configFile.source = ./config/config.nu;
    shellAliases = shellAliases;
    environmentVariables  = sessionVariables;
      # register ${pkgs.nushellPlugins.regex}/bin/nu_plugin_regex
    extraConfig = ''
      register "${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat"
      register "${pkgs.nushellPlugins.formats}/bin/nu_plugin_formats"
      register ${pkgs.nushellPlugins.query}/bin/nu_plugin_query
      register ${pkgs.nushellPlugins.net}/bin/nu_plugin_net

      # maybe useful functions
      # use ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/to-number-format.nu *
      # use ${pkgs.nu_scripts}/share/nu_scripts/sourced/api_wrappers/wolframalpha.nu *
      # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/job.nu *
      # use ${pkgs.nu_scripts}/share/nu_scripts/modules/network/ssh.nu *
      source "${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu"
      source "${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu"
      source "${pkgs.nu_scripts}/share/nu_scripts/modules/nix/nix.nu"
      
      # completions
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/btm/btm-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/tealdeer/tldr-completions.nu *
      use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/zellij/zellij-completions.nu *
    '';
    extraEnv = ''
      use "${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/catppuccin-mocha.nu"
      $env.config = {
        color_config: (catppuccin-mocha),
        hooks: {
          pre_prompt: [(source ${pkgs.nu_scripts}/share/nu_scripts/nu-hooks/direnv/config.nu)]
        }
      }
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "macos" "dircycle" "timer" "sudo" "web-search" "dirhistory" "history" "jsontools" ];
      theme = "robbyrussell";
    };
    sessionVariables = sessionVariables;
    localVariables = {
      TERM="xterm-256color";
    };
    plugins = [
      # using this it's not easy to compare the different nix-shell
      # {
      #   name = "zsh-nix-shell";
      #   file = "nix-shell.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "chisui";
      #     repo = "zsh-nix-shell";
      #     rev = "v0.5.0";
      #     sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
      #   };
      # }
    ];
    initExtra = ''
      ${transfer_script}
      # Enable Nix
      # . /home/jacky/.nix-profile/etc/profile.d/nix.sh
      # Enable Mvn
      # export NVM_DIR="$HOME/.nvm"
      # [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      # [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
      export NIXPKGS_ALLOW_UNFREE=1
    '';
    # initExtra = ''
    #   # setopt no_nomatch # Compatible bash wildcard
    #   unsetopt correct  # Disable AutoCorrect

    #   # Promt themes
    #   # autoload -U promptinit; promptinit
    #   # PURE_PROMPT_SYMBOL=›
    #   # PURE_PROMPT_VICMD_SYMBOL=‹
    #   # prompt pure
    #   # source minimal.zsh
    #   source ${./oxide.zsh-theme}

    #   # Compatibility bash completion
    #   # autoload -U bashcompinit && bashcompinit
    #   # source ${../overlays/nixos-helper/ns.bash}

    #   # allow using nix-shell with zsh
    #   ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin

    #   # Completions
    #   zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive tab completion
    #   zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" # Colored completion (different colors for dirs/files/etc)
    #   zstyle ':completion:*' menu select                        # Hit 'TAB' to select

    #   # Color man pages
    #   export LESS_TERMCAP_mb=$'\E[01;32m'
    #   export LESS_TERMCAP_md=$'\E[01;32m'
    #   export LESS_TERMCAP_me=$'\E[0m'
    #   export LESS_TERMCAP_se=$'\E[0m'
    #   export LESS_TERMCAP_so=$'\E[01;47;34m'
    #   export LESS_TERMCAP_ue=$'\E[0m'
    #   export LESS_TERMCAP_us=$'\E[01;36m'
    #   export LESS=-R

    #   # Bash-like navigation between words
    #   autoload -U select-word-style
    #   select-word-style bash

    #   # Keybindings
    #   bindkey -e                               # Emacs keybinding
    #   bindkey  "^[[3~"  delete-char            # Del key
    #   bindkey  "^[[H"   beginning-of-line      # Home key
    #   bindkey  "^[[F"   end-of-line            # End key
    #   bindkey '^[[5~' history-beginning-search-backward # Page up key
    #   bindkey '^[[6~' history-beginning-search-forward  # Page down key
    #   bindkey "\e[27;2;13~" accept-line        # Shift - enter
    #   bindkey "\e[27;5;13~" accept-line        # Ctrl - enter
    #   bindkey '^H' backward-kill-word          # Ctrl - backspace
    #   bindkey "^[[1;5C" forward-word           # Ctrl - ->
    #   bindkey "^[[1;5D" backward-word          # Ctrl - <-
    #   bindkey "^[[1;3C" forward-word           # Alt - ->
    #   bindkey "^[[1;3D" backward-word          # Alt - <-
    # '';
  };

}

