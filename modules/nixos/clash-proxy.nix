{ pkgs, lib, config, ... }: 
with lib; let
  cfg = config.services.clash-proxy;
in {
  options.services.clash-proxy = {
    enable = mkEnableOption "clash-proxy";

    proxy-addr = mkOption {
      type = types.str;
      default = "https://127.0.0.1:7897";
      description = "Address displayed by network proxy software";
    };
  };

  config = mkIf cfg.enable {
    networking.proxy = {
      httpProxy  = cfg.proxy-addr; 
      httpsProxy = cfg.proxy-addr;
      allProxy   = cfg.proxy-addr;
    };

    # programs.git = {
    #   extraConfig = {
    #     "https"."https://github.com".proxy = cfg.proxy-addr;
    #     "http"."https://github.com".proxy  = cfg.proxy-addr;
    #   };
    # };

    programs.clash-verge = {
      enable = true;
      tunMode = true;
      autoStart = true;
      package = pkgs.unstable.clash-verge-rev;
    }; 
  };
}
