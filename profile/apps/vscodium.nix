# Ref:
# 1. https://github.com/wineee/nixos-config/blob/master/pkgs/vscodium.nix
# 2. https://github.dev/poscat0x04/nixos-configuration
{ pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions; [
    # Add nixpkgs's vscode-extensions
    matklad.rust-analyzer
    vadimcn.vscode-lldb
    ms-python.python
    redhat.vscode-yaml
    vscodevim.vim
    # bbenoist.Nix
    # justusadam.language-haskell
    # dhall.dhall-lang
    # dhall.vscode-dhall-lsp-server
    # haskell.haskell
    # banacorn.agda-mode
    serayuzgur.crates
    # jscearcy.rust-doc-viewer
    # arcticicestudio.nord-visual-studio-code
    # pKief.material-icon-theme
    # dbaeumer.vscode-eslint
    timonwong.shellcheck
    # wayou.vscode-todo-highlight
    # maximedenes.vscoq
    # james-yu.latex-workshop
    # GitHub.vscode-pull-request-github
    # # mr-konn.generic-input-method
    # christian-kohler.path-intellisense
    # aaronduino.nix-lsp
    # ms-vscode.hexeditor
    # be5invis.toml
    # # jroesch.lean
    # # huytd.nord-light
    # akamud.vscode-theme-onelight
    # # berberman.vscode-cabal-fmt
    # Gruntfuggly.todo-tree
    # # # LDIF
    # # jtavin.ldif
    # # # c stuff
    # # ms-vscode.cmake-tools
    # # twxs.cmake
    # # cschlosser.doxdocgen
    # # llvm-vs-code-extensions.vscode-clangd
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # {
    #   name = "remote-ssh-edit";
    #   publisher = "ms-vscode-remote";
    #   version = "0.47.2";
    #   sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    # }
  ];
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = extensions;
  };
in
vscodium-with-extensions


