# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./services.nix
  ];

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
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    package = pkgs.nixFlakes;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than-14d";
      dates = "weekly";
    };
  };
  
  # TODO: Set your hostname
  networking = {
    hostName = "nixos";
    # proxy.default = "https://user:passwd@proxy:prot/";
    networkmanager.enable = true;
  };

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader = {
    systemd-boot = {
      enable = true;
      extraEntries = {
        "UkyinUbuntu.conf" = ''
          title UkyinUbuntu
          efi /efi/ubuntu/shimx64.efi
        '';
      };
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  i18n = {
    # defaultLocale = "C.UTF-8";
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.enableRimeData = true;
      fcitx5.addons = with pkgs; [
	fcitx5-rime 
        fcitx5-chinese-addons 
        fcitx5-table-extra 
      ];
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };
  
         
  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.defaultUserShell = pkgs.zsh;
  users.users = {
    # FIXME: Replace with your username
    jacky = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
	      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD5Rf2rSlpYwc+euAnZG6RB2mBNkrfApMIf+yGVT9GFotnvVHyejn+X/7Lw1VTy9IcajXd2MbGvxrwHcVqPfe0wt7GrEcEkhPyeooUXfq+i7WY03ClOHai7uNwbotfqra9wtTRJ8gzmXTq5Q3CaMyHwY7SymK6DdWnpCeVvszzasaqcF3nYdhFVfjLm7gbCB2P+6VNE6dXEkNtihrK3NTcPbZ/yCF16QJg7ePKDbu4/GEMUtFuF0fJL6kUgDYI7NlhQvGnAREfa7tHPrJZR1sqnpg7BVunUC79IwxxZHEEWokU0bOHozOm/6n4rg9b8JPw8AFsU7ZtC4bihg2XcjlF0/nxpPOmgbRrPHYvLWdWxtbMiuCYVKrNUNG2IBrq3T8m/acmDyFOCzN3TOW60XMKzBcPxe5vCssbRG8sKihKeh/1byP8HCvwqFkTbPZMwpq3ploHbCsVw/KDOk7dwvYyM1JS09kBJjnaV2r6owrNKVS8Su4sLC8lXOnEh5VgWm0= 18922251299@163.com"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
	      patchelfStable
      ];
    };
  };


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
