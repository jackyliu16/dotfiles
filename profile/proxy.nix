# Ref on: https://proof-relevant.systems/ics-fp/#/page/ics-fp-1
{ pkgs
, enableClashProxy ? false
, ... }: {

  # NOTE: programs.clash-verge has been call in nixos, it's a NixOS options.

  systemd.services.nix-daemon.environment = {
    http_proxy  = "https://127.0.0.1:7897";
    https_proxy = "https://127.0.0.1:7897";
  };

  # launchd.daemons.nix-daemon.serverConfig.EnvironmentVariables.http_proxy  = "https://127.0.0.1:7897"; # What the fuck ?
  # launchd.daemons.nix-daemon.serverConfig.EnvironmentVariables.https_proxy = "https://127.0.0.1:7897";

  programs.git = {
    extraConfig = if enableClashProxy then {
      "http"."https://github.com".proxy = "http://127.0.0.1:7897";
      "https"."https://github.com".proxy = "http://127.0.0.1:7897";
    } else { };
  };
}
