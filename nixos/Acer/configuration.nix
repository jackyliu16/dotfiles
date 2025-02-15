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

    ../pkgs
    ./applications.nix
    ./games.nix
    ./nbfc.nix

    ./kde.nix
    ../fonts.nix
    ../inputMethod.nix

    outputs.nixosModules.clash-proxy
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.nur.overlay
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
      permittedInsecurePackages = [
        "electron-27.3.11" # use by logseq define in application.nix
      ];
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
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store" 
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
    trusted-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [ "jacky" ];
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "05:45" ]; # Optional; allows customizing optimisation schedule

  nix.gc = {
    automatic = false; # NOTE: use nh instead
    options = "--delete-older-than-7d";
    dates = "weekly";
  };

  networking = {
    hostName = "ANixOS";
    networkmanager.enable = true;
    # networking.wireless.enable = true;
    extraHosts = builtins.readFile (builtins.toString (pkgs.fetchurl {
      url = "https://raw.hellogithub.com/hosts";
      hash = "sha256-m4YAaNyplO4UcXFEEa30KBQWIkB0yF1MPqbiGb8UfmQ=";
    }));
  };

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.memtest86.enable = true;
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
    extraModprobeConfig = ''
      # fix speaker 
      # https://github.com/torvalds/linux/blob/830b3c68c1fb1e9176028d02ef86f3cf76aa2476/sound/pci/hda/patch_realtek.c#L1622C36-L1622C42
      # https://bbs.archlinuxcn.org/viewtopic.php?id=13238
      options snd_hda_intel index=1 model=3stack
    '';
  };

  users.users = {
    jacky = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmoa8ZWn22hhY9OB8miiGjyjg8n57/Acrc5PlTjqJZSxQCDN5/9NXxnpkZCTVI9ly/G2bKVXt3E+NAOxHW3EHRulRIEHevHIY6wkDZhZwIS2rgue+sijPxqkr7FIBooHSlMQE38PMHW17GzbzDrebVoOhu1OxEqU4dOyy7mw7sFdh9IMI4qWHtn9HhAZo6hgz1XKeO8syitbMmsgdoPgSm2QruDVbS3cdgP3pqKSDwJmeq+CPJEgLvMvqDLHOgJ4xdr6/heDLapOkoKlxaPmLB9gx3u6XTmPd0to7Lg+PiiPSytMekBM8iUJlmb6M0egU/tzsTkt9YCGHQzNzLGjc+fQyzXIF4D3y07O7kp5jl9nBO96L/k0lLARByOxpHDEfCxZiLLLov2VNY2jCGWiQo+tK0q77/yj2kSzroOR6tXdem0ir1Cf0iytD4/VIk7AdbQ64AJE4PHIyj5RnNtnGpsAvHwBJ7z178g6y4tPkQIjqMDlY1MRZmCKd3l2nlBg8= 18922251299@163.com"
      ];
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
      LoginGraceTime = 10;
    };
  };

  time.timeZone = "Asia/Shanghai";

  services = {
    # GNOME
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;

    # Enable plasma6 Desktop Environment 
    displayManager.sddm.enable = true; 
    desktopManager.plasma6.enable = true;

    xserver = {
      # X11 windowing services
      enable = true;
      # Key-mapping
      xkb.layout = "cn";
      xkb.variant = "";
      videoDrivers = [ "nvidia" ];

      # Deepin
      # displayManager.lightdm.enable = true;
      # desktopManager.deepin.enable = true;

      # Pantheon(密钥管理似乎有问题)
      # desktopManager.pantheon.enable = true;
      # displayManager.lightdm.enable = true;

      # CDE(unlogin able)
      # desktopManager.cde.enable = true;
      # displayManager.lightdm.enable = true;

      # LXQT 
      # desktopManager.lxqt.enable = true;
      # displayManager.lightdm.enable = true;

      # Lumina(network issue) 
      # desktopManager.lumina.enable = true;
      # displayManager.lightdm.enable = true;
    };

    # Enable plasma5 Desktop Environment 
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;

    # Enable cinnamon
    # displayManager.lightdm.enable = true;
    # desktopManager.cinnamon.enable = true;
    # services.cinnamon.apps.enable = true;

    # Mate(bad)
    # desktopManager.mate.enable = true;
    # displayManager.lightdm.enable = true;

    # XFCE(little bad)
    # desktopManager.xfce.enable = true;
    # displayManager.lightdm.enable = true;

    # Budgie(playable) 
    # desktopManager.budgie.enable = true;
    # displayManager.lightdm.enable = true;
  };

  # enable CUPS to print documents 
  services.printing.enable = true;
  services.tailscale.enable = true;
  
  # File Share Between Operating System
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    shares = {
      public = {
        path = "/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "jacky";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  sound.enable = true;

  hardware.pulseaudio.enable = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # media-session.enable = true;
  };

  services.clash-proxy = {
    enable = true;
    proxy-addr = "http://127.0.0.1:7897";
  };

  # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.dev.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/jacky/.config/dotfiles/";
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  environment.systemPackages = with pkgs; [ 
    mangohud 
    # blackbox-terminal
    # zotero
    # kermit
    # vim
    # texmaker
    # docker-compose
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  programs.coolercontrol.enable = true;
  programs.coolercontrol.nvidiaSupport = true;
  programs.appimage.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  services.flatpak.enable = true;
}
