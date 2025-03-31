{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";  # 替换为你的磁盘设备
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
                mountpoint = "/boot/efi";
                mountOptions = [
                  "umask=0077"
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };

            # Btrfs 根分区
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountOptions = [ 
                  "compress=zstd"  # 启用透明压缩
                  "noatime"        # 减少写入
                ];

                # Btrfs 子卷配置
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" "compress=zstd" ];
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
