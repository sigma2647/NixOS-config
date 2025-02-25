{ config, lib, pkgs, ... }: {
  # 导入硬件配置
  imports =
    [ # Include the results of the hardware scan.
      ./packages.nix
      ./hardware-configuration.nix
      ../../modules/services/tailscale.nix
      ../../modules/network/host.nix
      # ../../modules/services/samba.nix
      ../../modules/samba
      ../../modules/python
      ../../modules/services/openssh.nix
    ];


  modules.python = {
    enable = true;
    pythonVersion = "python312";
    enableNumpy = true;
    enableDevelopment = true;
    extraPackages = with pkgs.python312Packages; [
      requests
      pyyaml
    ];
  };

  # 使用 systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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


  # 开启 nix flakes
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = ["root" "sigma" "lawrence"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # 设置时区
  time.timeZone = "Asia/Shanghai";

  # 设置网络
  networking = {
    hostName = "jy-vm-nix"; # 改成你想要的主机名
    networkmanager.enable = true;
  };


  # 用户
  users.users.lawrence = {                   # 将 'xing' 替换为你的用户名
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
    stdenv.cc.cc.lib
    uv
    ffmpeg
    # iptables

  ];


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

  programs.nix-ld.enable = true;
  # nix.settings.substituters = lib.mkForce [
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  #   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
  #   "https://mirror.sjtu.edu.cn/nix-channels/store"
  #   # 把官方源放在最后
  #   "https://cache.nixos.org"
  # ];
}
