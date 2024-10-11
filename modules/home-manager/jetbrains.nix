# Refs on
# https://github.com/NikSneMC/NikSOS/blob/main/pkgs/ja-netfilter/default.nix
# https://github.com/spikespaz/dotfiles/blob/352ce1a9b728f097bc3062fce95e07d11512a8b9/packages/ja-netfilter/base.nix
{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib) types;

  cfg = config.programs.jetbrains;

  patchIDEs = builtins.map (ide: ide.overrideAttrs {
    vmopts = ''
      --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
      --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

      -javaagent:${pkgs.ja-netfilter}/ja-netfilter.jar=jetbrains
    '';
  });
in
{
  options = {
    programs.jetbrains = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable JetBrains via ja-netfilter crack.";
      };
      packages = lib.mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "A list of packages need to enable ja-netfilter.";
        example = [ pkgs.jetbrains.idea-ultimate ];
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.packages != [ ]) {
    programs.jetbrains-remote = {
      enable = true;
      ides = patchIDEs cfg.packages;
    };
    home.packages = (patchIDEs cfg.packages) ++ [ pkgs.ja-netfilter ];
  };

  # https://jetbra.in/5d84466e31722979266057664941a71893322460
}
