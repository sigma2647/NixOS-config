# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
  efi.efiSysMountPoint = "/boot/efi";
  timeout = 5;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      efiInstallAsRemovable = true;
      default = "saved";
    };
  };

  networking.hostName = "nix-home"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";   # 语言设置
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # 配置 Nix 的 channels
  nixpkgs.config.allowUnfree = true;    # 允许安装非自由软件

  # 用户
  users.users.sigma = {                   # 将 'xing' 替换为你的用户名
    isNormalUser = true;
    createHome = true;
		extraGroups = [ "wheel" "networkmanager" ]; # 允许用户使用 sudo
    packages = with pkgs; [              # 默认安装的用户包
      vim
      wget
      htop
    ];
  };

  # 启用 sudo
  security.sudo.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  systemd.services.NetworkManager.enable = true;
  networking.networkmanager.enable = true;


   # 启用 SSH 服务
  services.openssh.enable = true;

  # 防火墙
  networking.firewall.enable = false;

  # 启用打印服务
  services.printing.enable = true;

  # 启用开机自动更新
  # system.autoUpgrade.enable = true;

  # 系统环境变量
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    curl

    tmux
    kitty
    lf
    lazygit

    #firefox
    #hyprland                   # 安装 Hyprland
    #waybar                     # 可选: Wayland 状态栏
    #wofi                       # 可选: 应用启动器
    #dunst                      # 可选: 通知管理器

    #fcitx5
    #fcitx5-configtool

    networkmanager
    networkmanagerapplet
    openssh

    #gtk2
    #gtk3
    #gtk4
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    }
  };


  system.stateVersion = "24.05"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" "nowatchdog" ];
}

