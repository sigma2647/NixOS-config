# disko-config.nix
{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-BIWIN_SSD_2236064901331";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "fmask=0077" "dmask=0077" "noexec" "nodev" "nosuid" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              mountOptions = [ "compress=zstd:1" "ssd" "noatime" "discard=async" ];
              subvolumes = {
                "/nix" = { mountpoint = "/nix"; };
                "/home" = { mountpoint = "/home"; };
                "/root" = { mountpoint = "/"; };
                "/var/log" = { mountpoint = "/var/log"; };
                "/tmp" = { mountpoint = "/tmp"; mountOptions = [ "noatime" "nodiratime" ]; };
                "/swap" = { mountpoint = "/swap"; mountOptions = [ "nodatacow" ]; };
              };
            };
          };
        };
      };
    };
  };

  # 系统配置部分（configuration.nix）
  swapDevices = [{
    device = "/swap/swapfile";
    size = 32768;  # 32G
  }];

  services.btrfs.autoScrub.enable = true;
  security.apparmor.enable = true;
  boot.kernelParams = [ "slab_nomerge" "pti=on" ];
}
