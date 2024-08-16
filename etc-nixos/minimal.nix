# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  # 使用的 NixOS 版本
  imports =
    [ 
      ./hardware-configuration.nix  # 自动生成的硬件配置文件
    ];

  # NixOS 系统配置
  #
  #
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.loader.grub.device = "/dev/sda"; # 将 /dev/sda 替换为你的引导盘
  networking.hostName = "nixos";        # 主机名
  networking.useDHCP = true;            # 使用 DHCP 获取网络配置
  time.timeZone = "Asia/Shanghai";      # 时区设置
  i18n.defaultLocale = "en_US.UTF-8";   # 语言设置
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # 配置 Nix 的 channels
  nixpkgs.config.allowUnfree = true;    # 允许安装非自由软件

  # 用户
  users.users.xing = {                   # 将 'xing' 替换为你的用户名
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 允许用户使用 sudo
    packages = with pkgs; [              # 默认安装的用户包
      vim
      wget
      htop
    ];
  };

  # 启用 sudo
  security.sudo.enable = true;

  networking.firewall.enable = false;

  # 图形界面设置
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  
  # 如果使用 NVIDIA 显卡
  hardware.nvidia = {
    mklib = true;
    modesetting.enable = true;
  };

  # 启用 NetworkManager 网络管理器
  networking.networkmanager.enable = true;

  # 启用 sudo
  security.sudo.enable = true;

  # 启用 Wayland 和 Hyprland
  services.xserver.enable = true;
  services.xserver.displayManager = {
    lightdm.enable = true;               # 使用 LightDM 作为显示管理器
    lightdm.greeters.gtk.enable = true;  # GTK 风格的登录界面
  };

  # 启用 SSH 服务
  services.openssh.enable = true;

  # 防火墙
  networking.firewall.enable = true;

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
    firefox
    hyprland                   # 安装 Hyprland
    waybar                     # 可选: Wayland 状态栏
    wofi                       # 可选: 应用启动器
    dunst                      # 可选: 通知管理器
    kitty
    thunar                     # 可选: 文件管理器

    fcitx
    fcitx-configtool

    networkmanagernetworkmanagerapplet
    networkmanagerapplet

    gtk2
    gtk3
    gtk4
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ]
  }


  programs.steam.enable = true;

  # 声音设置
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Swap 文件 (可选)
  # swapDevices = [ { device = "/swapfile"; size = 4096; } ];

  # 定制 Shell
  programs.zsh.enable = true;
  programs.zsh.enableAutocomplete = true;
  programs.zsh.enableSyntaxHighlighting = true;

  # 启用时钟同步
  systemd.timers.systemd-timesyncd.enable = true;

  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  fonts.enableFontDir = true;
  fonts.fontconfig.enable = true;
}

