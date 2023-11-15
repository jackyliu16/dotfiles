{ user, domain }: { config, pkgs, ... }: let
  repo_path = "$HOME/.config/NixOS-Config";
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

  imports = [
    ./apps/zsh.nix
  ];

  # NOTE: enable fonts catch
  fonts.fontconfig.enable = true;

  # NOTE: this repo should be located in $HOME/.config
  # I have no ideas but it just not working.
  home.shellAliases = {
    ccfg="cd $HOME/.config/NixOS-Config";
    hms="nix build ${repo_path}#homeConfigurations.'${user}@${domain}'.activationPackage && ${repo_path}/result/activate";
    # TODO: haven't check yet
    oss="sudo nixos-rebuild switch --flake ${repo_path}/.";
  };
}