{ pkgs
, inputs
, enableNixDev ? false
, ... }: {
  imports = [
    # ./apps/vim.nix
    (import ./apps/neovim/default.nix { inherit inputs pkgs ; })
    (import ./apps/neovim/packages.nix { inherit inputs pkgs ; })
    ./apps/helix.nix
    ./apps/shells.nix
    ./apps/zellij.nix
    ./direnv.nix
  ];

  home.packages = (with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    tree        # File Struct
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep
    tmux        # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    ranger      # File Explorer
    just        # Justfile
    xxd         # Read Hex Files
    cloc        # A program that counts lines of source code
    dtc         # Device Tree Compiler
    unzip       # 

    # Proxy
    cachix

    # Network
    ethtool
    wireshark   # It looks like collision with tshark
    # tshark
    tcpdump
    nettools    # net-tools
    speedtest-cli

    # Helix Request
    # clang
    # libclang
    rust-analyzer
    nil
    gopls
    taplo
    pyright
    # pylsp

    # Coding
    gnumake
  ]) ++ (if enableNixDev then with pkgs; [ 
    # nix-init
    nixpkgs-fmt
    # (writeShellScriptBin "nrepl" ''
    #   export PATH=${pkgs.coreutils}/bin:${pkgs.nixUnstable}/bin:$PATH
    #   if [ -z "$1" ]; then
    #      nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" ${./apps/nrepl.nix}
    #    else
    #      nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') ${./apps/nrepl.nix}
    #    fi
    # '')
  ] else [] );
}
