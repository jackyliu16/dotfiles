{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.kdePackages; [
    partitionmanager  # Manage the disk devices, partitions and file systems
    filelight         # Quickly visualize your disk space usage
    zanshin           # TEST ?
    yakuake           # Drop down terminal
  ];
}
