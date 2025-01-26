{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";  # 替换为你的磁盘设备
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI 引导分区
            ESP = {
              type = "EF00";  # EFI 分区类型
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            # Swap 分区
            swap = {
              size = "32G";
              content = {
                type = "swap";
              };
            };

            # Btrfs 根分区
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountOptions = [ "compress=zstd" "ssd" "noatime" ];  # 启用压缩和 SSD 优化

                # Btrfs 子卷配置
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                  };
                  "/home" = {
                    mountpoint = "/home";
                  };
                  "/root" = {
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
