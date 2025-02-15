flakeArgs@{ pkgs, lib, inputs, outputs, ... }:
{ user
, domain
, ... }: let
  repo_path = "$HOME/.config/dotfiles";
in {
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.sessionVariables = {
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
  };
  home.stateVersion = "24.05";
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
    nhos="nh os switch ${repo_path} -c '${user}@${domain}' ";
    nhhs="nh home switch ${repo_path}";
    send="curl -F 'c=@-' 'https://fars.ee/'";
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

    extraConfig = { # https://github.com/kalekseev/dotfiles/blob/59d930c9de043b0ae73e48e0ee1a2874212eb855/flake.nix#L271
      core.editor = "nvim";
      github.user = "jackyliu16";
      color.ui = "auto";
      color.status = {
        added = "green";
        changed = "yellow";
        untracked = "cyan";
      };
      push.default = "current";
      push.autoSetupRemote = true;
      pull.ff = "only";
      grep = {
        extendRegexp = true;
        lineNumber = true;
      };
      merge = {
        tool = "vimdiff";
        conflictstyle = "zdiff3";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
        vimdiff.cmd = "nvim -d $LOCAL $BASE $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        p4merge.cmd = "p4merge $BASE $LOCAL $REMOTE $MERGED";
      };
      init.defaultBranch = "master";
      diff.algorithm = "histogram";
      pager.difftool = true;
      rerere.enabled = true;
      branch.sort = "-committerdate";
      rebase = {
        autosquash = true;
      };
    };
    # lfs.enable = true;
    # lfs.skipSmudge = true;
  };

  # extraConfig = if enableClashProxy then {
  #   "http"."https://github.com".proxy = "http://127.0.0.1:7897";
  #   "https"."https://github.com".proxy = "http://127.0.0.1:7897";
  # } else { };
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
