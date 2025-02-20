{ config, lib, pkgs, ... }: {
  # 导入硬件配置
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/services/tailscale.nix
      ../../modules/network/host.nix
      # ../../modules/services/samba.nix
      ../../modules/services/openssh.nix
    ];

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
    # iptables
  ];


  # 防火墙
  networking.firewall.enable = true;

  # 允许非自由软件（如果需要）
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # 使用你安装时的 NixOS 版本

  nix.settings.substituters = lib.mkForce [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    # 把官方源放在最后
    "https://cache.nixos.org"
  ];
}
