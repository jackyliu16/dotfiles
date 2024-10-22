{ pkgs, lib, ... }: {
  services.redshift = {
    enable = true;

    latitude = 23.1291;
    longitude = 113.2644;

    temperature = {
      day = 5500;
      night = 3700;
    };
  };
}
