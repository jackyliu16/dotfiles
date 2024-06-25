{ user 
, domain
, enableClashProxy ? false
, inputs
, outputs
}: { config, pkgs, ... }: let
  repo_path = "$HOME/.config/dotfiles";
in {
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.sessionVariables = rec {
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
  };
  home.stateVersion = "22.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [ ];

  # NOTE: enable fonts catch
  fonts.fontconfig.enable = true;

  # NOTE: this repo should be located in $HOME/.config
  # I have no ideas but it just not working.
  home.shellAliases = {
    ccfg="cd ${repo_path}";
    hms="nix build ${repo_path}#homeConfigurations.'${user}@${domain}'.activationPackage && ${repo_path}/result/activate";
    # TODO: haven't check yet
    oss="sudo nixos-rebuild switch --flake ${repo_path}#${domain}";
    osb="sudo nixos-rebuild boot --flake ${repo_path}#${domain}";
  };
  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [
      "*~"
      "*.swp"
    ];
    aliases = {
      gpa = "push --all";
    };
    userEmail = "18922251299@163.com";
    userName = "jackyliu16";
    extraConfig = if enableClashProxy then {
      "http"."https://github.com".proxy = "http://127.0.0.1:7897";
      "https"."https://github.com".proxy = "http://127.0.0.1:7897";
    } else { };
  };
  home.packages = with pkgs; [
    wget curl
    cron # Run Script in Scheduled
  ] ++ (with pkgs.unstable; [
    # clash-verge-rev
  ]);

  # TODO not sure if working
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      # (final: prev: {
      #   clash-verge-rev = final.clash-verge.overrideAttrs (oldAttrs: rec {
      #     version = "1.5.11";
      #     src = builtins.fetchurl {
      #       url = "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v${version}/clash-verge_${version}_amd64.deb";
      #       sha256 = "sha256:1rf9c2bq2vq81l420l6j04bshxaf4baw3k405bkv04qjgq45d0qn";
      #     };

      #     installPhase = ''
      #       runHook preInstall
      #       mkdir -p $out/bin
      #       mv usr/* $out
      #       rm $out/bin/clash-meta
      #       runHook postInstall
      #     '';
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
}
