# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { }
, binutils ? (import pkgs.binutils {} )
, ... }: rec {
  # example = pkgs.callPackage ./example { };
  mapPackages = f: with binutils; listToAttrs (
    map
    (name: {
      inherit name;
      value = f name;
    })
    (filter (v: v != null)
      (attrValues
        (mapAttrs (k: v: if v == "directory" && k != "_source" then k else null) (readDir ./.))))
  );
  packages = pkgs: mapPackages (name: pkgs.${name});
  overlays = final: prev: mapPackages (name:
    let
      sources = (import ./_source/generated.nix) { inherit (final) fetchurl fetchgit fetchFromGitHub; };
      packages = import ./${name};
      args = binutils.intersectAttrs (binutils.functionArgs packages) { source = sources.${name}; };
    in
      final.callPackage packages args
  );
}
