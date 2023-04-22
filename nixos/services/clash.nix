{ lib
, pkgs
, config
, clash
, ... }:

with lib;                      
let
  cfg = config.services.clash;
in {
  options.services.clash = {
    enable = mkEnableOption "clash service";
    configuration_directory = mkOption {
      type = types.str;
      default = "/home/jacky/.config/clash";  # the home directory
    };
  };

  config = mkIf cfg.enable {
    systemd.services.clash = {
      wantedBy = [ "multi-user.target" ];
      # serviceConfig.ExecStart = "${pkgs.hello}/bin/hello -g'Hello, ${escapeShellArg cfg.greeter}!'";
      # nohup ${pkgs.clash}/bin/clash -f '${escapeShellArg cfg.greeter}' > /dev/null 2>&1
      serviceConfig.ExecStart = ''
        ${pkgs.clash}/bin/clash -d '${escapeShellArg cfg.configuration_directory}'
      '';
    };
  };
}