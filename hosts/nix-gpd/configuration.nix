{ config, lib, username, hostname , pkgs, pkgs-unstable, ... }: {
  # 导入硬件配置
  imports = [
    ../fonts.nix
    ./packages.nix
    ./hardware-configuration.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/flatpak
    ../../modules/system/time.nix
    ../../modules/network/host.nix
    ../../modules/ssd.nix
    ../../modules/zram.nix
    ../../modules/virt_manager.nix
    ../../modules/docker.nix
    # ../../modules/clash.nix

    # ../../modules/virtual.nix
  ];

  # 使用 systemd-boot
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";



  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    timeout = 5;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      efiInstallAsRemovable = true;
      default = "saved";
      # configurationLimit = 5;
      gfxmodeEfi = "1920x1200";
      theme = pkgs.catppuccin-grub;
    };
  };


  # 文件系统优化
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/nix" ];
  };





  # 设置网络
  networking = {
    hostName = hostname; # 改成你想要的主机名
    networkmanager.enable = true;
  };

  # 添加你的用户
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
    extraGroups = [ "wheel" "networkmanagr" "docker" "samba"];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # 启用 OpenSSH 后台服务
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      # PermitRootLogin = "no"; # disable root login
      # PasswordAuthentication = false; # disable password login
    };
    # openFirewall = true;
  };


  # services.getty.autologinUser = "lawrence";
  # services.xserver.enable = true;
  services.displayManager.ly.enable = true;

  documentation.enable = true;
  documentation.dev.enable = true;
  documentation.man.enable = true;


 
  # 允许非自由软件（如果需要）
  # nixpkgs.config.allowUnfree = true;  # 已通过 flake.nix 中的 specialArgs.pkgs 配置

  system.stateVersion = "24.11"; # 使用你安装时的 NixOS 版本
  environment.sessionVariables = {
    TERMINFO_DIRS = "${pkgs.ncurses}/share/terminfo";
    # LD_LIBRARY_PATH = "/run/current-system/sw/lib:$LD_LIBRARY_PATH";
  };

  # 系统优化
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 125;
  };
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "iomem=relaxed" "amd_pstate=active" ];
}

