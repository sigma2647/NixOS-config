{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";  # 虚拟机磁盘设备
        type = "disk";
        content = {
          type = "msdos";  # 使用MBR分区表(msdos)代替GPT，适用于BIOS
          partitions = {
            # BIOS启动分区
            boot = {
              size = "1M";
              type = "primary";
              flags = ["boot"];  # 设置boot标志
              priority = 1;  # 确保它是第一个创建的分区
            };
            # Btrfs根分区
            root = {
              size = "100%";  # 使用剩余所有空间
              type = "primary";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];  # 强制创建，覆盖任何已存在的文件系统
                mountOptions = [ 
                  "compress=zstd"  # 启用透明压缩
                  "noatime"        # 减少写入
                  "space_cache=v2" # 优化虚拟机性能
                  "discard=async"  # 对虚拟机提升性能
                ];
                # Btrfs子卷配置
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                  };
                  # 可选：为日志创建一个单独的子卷
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["subvol=log" "compress=zstd" "noatime"];
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
