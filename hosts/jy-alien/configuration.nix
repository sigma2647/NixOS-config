# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      # ../fonts.nix
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
      configurationLimit = 5;
    };
  };

  networking.hostName = "jy-alien"; # Define your hostname.
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
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  };


  # 用户
  users.users.sigma = {                   # 将 'xing' 替换为你的用户名
    isNormalUser = true;
    shell = pkgs.zsh;
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
  # services.xserver.videoDrivers = [ "nvidia" ];

  # services.displayManager.sddm.enable = true;
  systemd.services.NetworkManager.enable = true;
  networking.networkmanager.enable = true;


   # 启用 SSH 服务
  services.openssh.enable = true;

  # 防火墙
  networking.firewall.enable = false;

  # 启用打印服务
  services.printing.enable = true;


  services.flatpak.enable = true;

  # 启用开机自动更新
  # system.autoUpgrade.enable = true;

  # 系统环境变量
  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    curl
    btop

    tmux
    kitty
    lf
    lazygit

    fastfetch

    zsh
    starship
    zoxide
    pyenv
    direnv
    fzf
    atuin

    ripgrep

    bat
    pstree
    nodejs

    xfce.thunar


    python3
    # zed
    # unstable.pywal16
    #
    gcc
    libffi
    openssl

    lan-mouse


    stow
    flatpak
    nautilus
    zathura

    firefox

    hyprland                   # 安装 Hyprland
    waybar                     # 可选: Wayland 状态栏
    rofi                       # 可选: 应用启动器
    #dunst                      # 可选: 通知管理器

    #fcitx5
    #fcitx5-configtool

    networkmanager
    networkmanagerapplet
    openssh
    home-manager

    #gtk2
    #gtk3
    #gtk4
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  # sound
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };


  system.stateVersion = "24.11"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" "nowatchdog" ];
}

