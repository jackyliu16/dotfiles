# Ref on
# https://github.com/nuko2MB/nix-config/blob/3ce30acd2a122f519b6d0f63b885dcdcaf538dda/lib/module/default.nix
{ lib, ... }:
with lib;
rec {
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt' = type: default: mkOpt type default null;

  ## Create a boolean NixOS module option.
  ##
  ## ```nix
  ## lib.mkBoolOpt true "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt = mkOpt types.bool;

  ## Create a boolean NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkBoolOpt true
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt' = mkOpt' types.bool;

  enabled = {
    ## Quickly enable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ true
    enable = true;
  };

  disabled = {
    ## Quickly disable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ false
    enable = false;
  };

  # Makes a simple module with an enable option
  mkModule =
    args: name: config:
    let
      prefix = "nuko";
      optName = [ prefix ] ++ (args.lib.toList name);
      optEnabled = args.lib.getAttrFromPath (optName ++ [ "enable" ]) args.config;
    in
    with args.lib;
    {
      options = setAttrByPath optName {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
      };

      config = mkIf optEnabled config;
    };

  # Makes a simple module with an enable option + a list of imports
  mkModule' =
    args: name: imports: config:
    let
      prefix = "nuko";
      optName = [ prefix ] ++ (args.lib.toList name);
      optEnabled = args.lib.getAttrFromPath (optName ++ [ "enable" ]) args.config;
    in
    with args.lib;
    {
      inherit imports;
      options = setAttrByPath optName {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
      };

      config = mkIf optEnabled config;
    };
}

