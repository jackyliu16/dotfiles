# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    # Or modules from other flakes (such as nixos-hardware): inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./virtualisation.nix
    # ./applications.nix
    ../fonts.nix
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

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    # auto-optimise-store = true;
    substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [ "jacky" ];
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "05:45" ]; # Optional; allows customizing optimisation schedule

  nix.gc = {
    automatic = true;
    options = "--delete-older-than-7d";
    dates = "weekly";
  };

  networking = {
    hostName = "ANixOS";
    networkmanager.enable = true;
    # networking.wireless.enable = true;
    extraHosts = builtins.readFile (builtins.toString (pkgs.fetchurl {
      url = "https://raw.hellogithub.com/hosts";
      sha256 = "sha256-MzaGFVPlEXFMFZH5A418HGCeKULWW8URfgW41ljlS0U=";
    }));
  };

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # loader.systemd-boot.enable = false;
    # loader.grub = {
    #   enable = true;
    #   efiSupport = true;
    #   device = "nodev";
    #   useOSProber = true;
    # };
    # loader.grub2-theme = {
    #   enable = true;
    #   theme = "tela";
    #   icon = "color";
    #   screen = "1080p";
    # };
  };

  users.users = {
    jacky = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [
      #   # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      # ];
      extraGroups = [ "wheel" "networkmanager" "docker"];
    };
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  services.xserver = {
    # X11 windowing services
    enable = true;
    # Key-mapping
    xkb.layout = "cn";
    xkb.variant = "";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # services.xserver = {
    # Enable plasma5 Desktop Environment 
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;

    # XFCE 
    # desktopManager.xfce.enable = true;
    # desktopManager.xterm.enable = false;
    # displayManager.defaultSession = "xfce";

    # GNOME
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;

    # Deepin
    # displayManager.lightdm.enable = true;
    # desktopManager.deepin.enable = true;
  # };

  # enable CUPS to print documents 
  services.printing.enable = true;
  services.tailscale.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # media-session.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.systemPackages = with pkgs; [
    # synology-drive-client
    # blackbox-terminal
    # zotero
    # kermit
    # vim
    # texmaker
    # docker-compose
  ];

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
    package = pkgs.unstable.clash-verge-rev;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
