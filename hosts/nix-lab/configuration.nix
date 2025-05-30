{ config, lib, username, hostname , pkgs, pkgs-unstable, ... }: {
  # 导入硬件配置
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services/tailscale.nix
      ../../modules/network/host.nix
      ../../modules/samba
      ../../modules/services/openssh.nix
    ];

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
    hostName = hostname; # 改成你想要的主机名
    networkmanager.enable = true;
    enableIPv6 = true;
  };


  # 用户
  users.users.${username} = {                   # 将 'xing' 替换为你的用户名
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "samba" ]; # 允许用户使用 sudo
    packages = with pkgs; [              # 默认安装的用户包
      vim
      wget
      htop
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  # 系统环境变量
  environment.systemPackages = with pkgs; [
    vim
    neovim
    
    git
    wget
    curl
    openssh
    tmux
    zoxide
    stow

    btrfs-progs
    compsize
    python3
    uv
    fastfetch
    nix-index
    proxychains-ng
  ];
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   stdenv.cc.cc.lib
  #   zlib
  # ];


  # 防火墙
  networking.firewall.enable = true;

  # 允许非自由软件（如果需要）
  # nixpkgs.config.allowUnfree = true;  # 已通过 flake.nix 中的 specialArgs.pkgs 配置

  system.stateVersion = "24.11"; # 使用你安装时的 NixOS 版本
}
