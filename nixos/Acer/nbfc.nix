{
  config,
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.nbfc-linux.packages.x86_64-linux.default
  ];
  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type = "simple";
    path = [pkgs.kmod];

    script = let
      configFile = pkgs.writeTextFile {
        name = "nbfc.json";
        text = ''
          {"SelectedConfigId": "Acer Nitro AN515-51"}
        '';
      };
    in
      "${inputs.nbfc-linux.packages.x86_64-linux.default}/bin/nbfc_service --config-file ${configFile}";
   
    wantedBy = ["multi-user.target"];
  };
  
}
