{ config, lib, pkgs, ... }: {
  # 导入硬件配置
  imports = [ ./hardware-configuration.nix ];

  # 使用 systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 文件系统优化
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/nix" ];
  };

  # 如果是 SSD
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # zram 配置
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # 系统优化
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 125;
  };

  # 基础系统工具
  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
  ];

  # 开启 nix flakes
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # 设置时区
  time.timeZone = "Asia/Shanghai";

  # 设置网络
  networking = {
    hostName = "nixos"; # 改成你想要的主机名
    networkmanager.enable = true;
  };

  # 添加你的用户
  users.users.your-username = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "password"; # 首次登录后要改
  };

  # 允许非自由软件（如果需要）
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11"; # 使用你安装时的 NixOS 版本
}
