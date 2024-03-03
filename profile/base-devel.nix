{ pkgs
, inputs
, enableNixDev ? false
, ... }: {
  imports = [
    # ./apps/vim.nix
    (import ./apps/neovim/default.nix { inherit inputs pkgs ; })
    ./apps/helix.nix
    ./apps/zsh.nix
    ./direnv.nix
  ];

  home.packages = (with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    tree        # File Struct
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep
    tmux        # Multiterminal Window Manager  
    zellij      # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    ranger      # File Explorer
    just        # Justfile
    xxd         # Read Hex Files
    cloc        # A program that counts lines of source code
    dtc         # Device Tree Compiler

    # Proxy
    cachix

    # Helix Request
    clang
    libclang
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
    (writeShellScriptBin "nrepl" ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.nixUnstable}/bin:$PATH
      if [ -z "$1" ]; then
         nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" ${./apps/nrepl.nix}
       else
         nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') ${./apps/nrepl.nix}
       fi
    '')
  ] else [] );
}
