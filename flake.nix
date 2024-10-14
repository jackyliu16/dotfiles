# This file contains basically inputs and outputs flakes of whole project
{
  description = "Jackyliu16's Simple flake about it's configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-idea-20240101.url = "github:nixos/nixpkgs/57610d2f8f0937f39dbd72251e9614b1561942d8";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Provide nix-locate search
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Run unpatched dynamic binaries on NixOS
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

        # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nur.url = "github:nix-community/NUR";

    # Home manager
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    # fenix.url = "github:nix-community/fenix";
    # fenix.inputs.nixpkgs.follows = "nixpkgs";
    # hardware.url = "github:nixos/nixos-hardware";

    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    # wallpaper.url = "github:h4m6urg1r/wallpapers";
    # wallpaper.inputs.nixpkgs.follows = "nixpkgs";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";

    # AstroNvim is an aesthetic and feature-rich neovim config.
    astronvim-template = { # https://docs.astronvim.com/configuration/v4_migration/
      url = "github:AstroNvim/template/main";
      flake = false;
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { self
    , nixpkgs
    , nixos-wsl 
    # , nixpkgs-unstable
    , nix-index-database
    , nix-ld
    , home-manager
    , rust-overlay
    , nur
    , astronvim-template
    , ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        QWNixOS = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/QiWsl/configuration.nix
            nixos-wsl.nixosModules.default
          ];
        };
        DNixOS = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            # nur.nixosModules.nur
            ./nixos/Dell/configuration.nix
            inputs.grub2-themes.nixosModules.default
            # inputs.wallpaper.nixosModules.default
            ({ pkgs, config, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [ 
                pkgs.rust-bin.nightly.latest.default
                # config.nur.repos.linyinfeng.matrix-wechat
                # config.nur.repos.xddxdd.wine-wechat
                # config.nur.repos.linyinfeng.icalingua-plus-plus
              ];
            })
          ];
        };
        ANixOS = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/Acer/configuration.nix
            nixosModules.kvmfr
            nix-ld.nixosModules.nix-ld
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "nixos@QWNixOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          # pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/QiWslNixOS/home.nix
          ];
        };
        "jacky@DDebian" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          # pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/DellDebian/home.nix
          ];
        };
        "jacky@DNixOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/DellNixOS/home.nix		
          ];
        };
        "jacky@AWDebian" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/AcerWSLDebianJacky/home.nix
          ];
        };
        "jacky@AWNixOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/AcerWSLNixOS/home.nix
          ];
        };
        "jacky@ANixOS" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/AcerNixOS/home.nix		
            nix-index-database.hmModules.nix-index
          ];
        };
      };
    };
  nixConfig = { # REF: https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"

      # nix community's cache server
      "https://nix-community.cachix.org"
      "https://zola.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [ # cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zola.cachix.org-1:NuHGH5vaZb05JjJIzx+rARDRys05gfoeJqIUSrS0VM4="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
