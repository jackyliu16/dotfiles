# Refs on 
# https://github.com/LostAttractor/flake/blob/eedb0b1888f69f4998f57747c1a066c2183db930/user/programs/jetbrains.nix
# https://github.com/spikespaz/dotfiles/blob/352ce1a9b728f097bc3062fce95e07d11512a8b9/packages/ja-netfilter/base.nix
{ config
, pkgs
, lib
, ... }:
let
  inherit (lib) types;

  cfg = config.programs.jetbrains;
    
  jetbra = pkgs.fetchFromGitHub {
    owner = "LostAttractor";
    repo = "jetbra";
    rev = "94585581c360862eab1843bf7edd8082fdf22542";
    sha256 = "sha256-9jeiF9QS4MCogIowu43l7Bqf7dhs40+7KKZML/k1oWo=";
  };

  vmoptions = pkgs.writeScript "vmoptions" ''
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

    -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
  '';

  generateOverridePackage = 
    pkgName: pkgName.overrideAttrs { vmoptsFile = vmoptions; }
    ;
in {
  options = {
    programs.jetbrains = {
        # enable = lib.mkOption { # lib.options.mkEnableOption
        #   type = types.lines;
        #   default = false;
        #   description = "Whether to enable JetBrains via ja-netfilter crack.";
        # };
        enable = lib.options.mkEnableOption "jetbrains";
        packages = lib.mkOption {
          type = types.listOf types.package;
          default = [];
          description = "A list of packages need to enable ja-netfilter.";
          example = [ pkgs.jetbrains.idea-ultimate ];
        };
      }; 
  };
  
  config = lib.mkIf cfg.enable {
    # cfg.enable = 
    #   cfg.packages != [];
    home.packages = map (pkg: generateOverridePackage pkg) cfg.packages;
  };

  # https://jetbra.in/5d84466e31722979266057664941a71893322460
}
