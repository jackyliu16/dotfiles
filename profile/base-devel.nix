{ pkgs, enableNixDev ? false, ... }: {
  imports = [
    ./apps/vim.nix
    ./apps/zsh.nix
  ];

  home.packages = with pkgs; [
    # Command Line Tools 
    tldr        # Command Helper 
    tree        # File Struct
    fzf         # File Name Searcher
    ripgrep     # File Content Searcher         ~ grep
    tmux        # Multiterminal Window Manager  
    zellij      # Multiterminal Window Manager  
    htop        # Resource Monitor              ~ top
    ranger      # File Explorer

    # Coding
    gnumake
  ] ++ (if enableNixDev then [
    nix-init
    nixpkgs-fmt
    (pkgs.writeShellScriptBin "nrepl" ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.nixUnstable}/bin:$PATH
      if [ -z "$1" ]; then
         nix repl --argstr host "$HOST" --argstr flakePath "$PRJ_ROOT" ${./apps/nrepl.nix}
       else
         nix repl --argstr host "$HOST" --argstr flakePath $(readlink -f $1 | sed 's|/flake.nix||') ${./apps/nrepl.nix}
       fi
    '')
  ] else [] );
}
