# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs }: {
  # example = pkgs.callPackage ./example { };
  # mkxp-z = builtins.fetchurl {
  #   url = "https://github.com/SamLukeYes/nix-custom-packages/blob/main/mkxp-z/default.nix";
  #   sha256 = "sha256-qI+ws7JnPCqYZJQFbGmTo9ICu6CFSCFSLxslXB5mcos=";
  # };
  mkxp-z = pkgs.callPackage ./mkxp-z.nix { };
  ja-netfilter = pkgs.callPackage ./ja-netfilter.nix { };
  ovital = pkgs.callPackage ./ovital.nix { };
  qtscrcpy = pkgs.callPackage ./qtscrcpy.nix { };
  rime-ice = pkgs.callPackage ./rime-ice.nix { };
  rime-frost = pkgs.callPackage ./rime-frost.nix { };
}
