{ config, lib, username, hostname , pkgs, pkgs-unstable, ... }: {
  # 导入硬件配置
  imports =
    [ # Include the results of the hardware scan.
      ../common.nix
      ./packages.nix
      ./hardware-configuration.nix
      ../../modules/services/tailscale.nix
      ../../modules/network/host.nix
      # ../../modules/services/samba.nix
      ../../modules/samba
      ../../modules/python
      ../../modules/services/openssh.nix
      ../../modules/docker.nix
      ../../modules/virtual/vmware.nix
    ];


  # 配置Python模块
  modules.python = {
    enable = true;
    enablePip = true;
    enablePipx = true;
    enableUv = true;
    enableNumpy = true;  # 如需科学计算库
    enableJupyter = false;  # 如需JupyterLab
    jupyterPort = 8888;  # 默认端口
    extraPackages = with pkgs.python3Packages; [
      # requests
      # pandas
      # 其他需要的Python包
    ];
  };

  # 使用 systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint  = "/boot/efi";

  # 文件系统优化
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/nix" ];
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

  i18n.defaultLocale = "en_US.UTF-8";   # 语言设置
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  # 设置网络
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };


  # 用户
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "samba" "docker" ]; # 允许用户使用 sudo
    packages = with pkgs; [              # 默认安装的用户包
      vim
      wget
      htop
    ];
  };

  users.users.samba-guest = {
    isSystemUser = true;
    group = "nogroup";
    description = "Samba guest user";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };


  # 防火墙
  # 开启防火墙并允许特定端口
  networking.firewall = {
    enable = true;  # 启用防火墙
    allowedTCPPorts = [ 80 443 8080 8888 ];  # 允许的TCP端口
    # allowedUDPPorts = [ 53 8080 8888 ];  # 允许的UDP端口
    allowedUDPPorts = [ 53 ];  # 允许的UDP端口
  };

  # 允许非自由软件（如果需要）
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # 使用你安装时的 NixOS 版本

  # programs.nix-ld.enable = true;
  # nix.settings.substituters = lib.mkForce [
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  #   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
  #   "https://mirror.sjtu.edu.cn/nix-channels/store"
  #   # 把官方源放在最后
  #   "https://cache.nixos.org"
  # ];
  # 设置全局环境变量
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.ncurses}/share/terminfo";
  };
}
