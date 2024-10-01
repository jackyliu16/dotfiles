# Refs on 
# https://github.com/LostAttractor/flake/blob/eedb0b1888f69f4998f57747c1a066c2183db930/user/programs/jetbrains.nix
# https://github.com/spikespaz/dotfiles/blob/352ce1a9b728f097bc3062fce95e07d11512a8b9/packages/ja-netfilter/base.nix
# https://discourse.nixos.org/t/overriding-configuring-jetbrains-vmopts/20675
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

  generateOverridePackage = 
    pkgName: pkgName.overrideAttrs { 
      vmopts = ''
        -Xms128m
        -Xmx2048m
        -XX:+HeapDumpOnOutOfMemoryError
        -XX:-OmitStackTraceInFastThrow
        -XX:+IgnoreUnrecognizedVMOptions
        -ea
        -Dsun.io.useCanonCaches=false
        -Dsun.java2d.metal=true
        -Djbr.catch.SIGABRT=true
        -Djdk.http.auth.tunneling.disabledSchemes=""
        -Djdk.attach.allowAttachSelf=true
        -Djdk.module.illegalAccess.silent=true
        -Dkotlinx.coroutines.debug=off
        -XX:CICompilerCount=2
        -XX:ReservedCodeCacheSize=512m
        -XX:CompileCommand=exclude,com/intellij/openapi/vfs/impl/FilePartNodeRoot,trieDescend
        -XX:SoftRefLRUPolicyMSPerMB=50
        -Dide.show.tips.on.startup.default.value=false
        -Dsun.tools.attach.tmp.only=true
        -Dawt.lock.fair=true
        -Djna.library.path=/nix/store/qlrbqz1k8c4dbr9xc3fgw9k04nqsw4ah-libsecret-0.21.4/lib:/nix/store/60ai8ki6cf85wbx2k4vwhsr4c891mar7-e2fsprogs-1.47.0/lib:/nix/store/ssq1sh0jhjlnmfic15lqy97953qhlfyh-libnotify-0.8.3/lib:/nix/store/7j8mbhf7c3sigq7lwl5vc5h7lhx34m6d-systemd-minimal-libs-255.6/lib


        --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
        --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

        -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
      '';
    }
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

  config = lib.mkIf (cfg.enable && cfg.packages != []) {
    home.packages = map (pkg: generateOverridePackage pkg) cfg.packages;
  };

  # https://jetbra.in/5d84466e31722979266057664941a71893322460
}
