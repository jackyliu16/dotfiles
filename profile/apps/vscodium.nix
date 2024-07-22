# Ref:
# 1. https://github.com/wineee/nixos-config/blob/master/pkgs/vscodium.nix
# 2. https://github.dev/poscat0x04/nixos-configuration
# 3. https://github.com/linuxmobile/kaku/blob/580d755a9f858677c0ef5c070aac3c3fa8f194e5/home/editors/vscode/default.nix#L7
{ inputs, pkgs, ... }:

let 
  vscode-marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = 
      (with pkgs.vscode-extensions; [

      ])
      ++ (with vscode-marketplace; [
        # Themes
        astro-build.astro-vscode
        catppuccin.catppuccin-vsc-icons
        mvllow.rose-pine
        re1san.tsuki
        jscearcy.rust-doc-viewer

        # Languages
        bbenoist.nix                # nix
        jnoortheen.nix-ide
        mkhl.direnv
        kamadorueda.alejandra         # formatter
        rust-lang.rust-analyzer     # Rust
        serayuzgur.crates
        # be5invis.toml               # Toml
        tamasfe.even-better-toml
        redhat.vscode-yaml          # Yaml
        ms-python.python            # Python 
        bradlc.vscode-tailwindcss   # CSS
        esbenp.prettier-vscode        # formatter of HTML relate
        formulahendry.auto-close-tag  # Add close </>
        james-yu.latex-workshop     # LaTex
        mr-konn.generic-input-method  # Unicode Symbol input

        # Common 
        christian-kohler.path-intellisense
        usernamehw.errorlens
        naumovs.color-highlight
        ms-vscode.hexeditor
        gruntfuggly.todo-tree
        fill-labs.dependi             # comprehensive dependency management extension(Rs, Go, JS, Py)
      ])
      ;
    userSettings = {
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.colorTheme" = "Tsuki";
      "editor.fontFamily" = "GeistMono Nerd Font, Catppuccin Mocha, 'monospace', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "files.trimTrailingWhitespace" = true;
      "terminal.integrated.fontFamily" = "GeistMono Nerd Font";
      "window.titleBarStyle" = "custom";
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.enableVisualBell" = false;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = false;
      "editor.minimap.enabled" = false;
      "editor.minimap.renderCharacters" = false;
      "editor.overviewRulerBorder" = false;
      "editor.renderLineHighlight" = "all";
      "editor.inlineSuggest.enabled" = true;
      "editor.smoothScrolling" = true;
      "editor.suggestSelection" = "first";
      "editor.guides.indentation" = true;
      "editor.guides.bracketPairs" = true;
      "editor.bracketPairColorization.enabled" = true;
      "window.restoreWindows" = "all";
      "window.menuBarVisibility" = "toggle";
      "workbench.panel.defaultLocation" = "right";
      "workbench.list.smoothScrolling" = true;
      "security.workspace.trust.enabled" = false;
      "explorer.confirmDelete" = false;
      "breadcrumbs.enabled" = true;
      "telemetry.telemetryLevel" = "off";
      "workbench.startupEditor" = "newUntitledFile";
      "editor.cursorBlinking" = "expand";
      "security.workspace.trust.untrustedFiles" = "open";
      "security.workspace.trust.banner" = "never";
      "security.workspace.trust.startupPrompt" = "never";
      "workbench.sideBar.location" = "right";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "workbench.editor.tabActionLocation" = "left";
      "window.dialogStyle" = "native";
    };
  };
}
