{
config,
inputs,
ouputs,
lib,
pkgs,
...
}:

{
  imports = [
    ../fonts.nix
    ./packages.nix
    ./hardware-configuration.nix
    ../../modules/services/tailscale.nix
    ../../modules/programs/kde-connect.nix
    ../../modules/system/time.nix
    ../../modules/system/hardware.nix
    # ../../modules/system/nvidia.nix
    ../../modules/virtual.nix
    ../../modules/docker.nix
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


  documentation.enable = true;
  documentation.dev.enable = true;
  documentation.man.enable = true;

  # gtk = {}

  networking.hostName = "nix-home"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  i18n.defaultLocale = "en_US.UTF-8";   # 语言设置
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-nord            # a color theme
      fcitx5-configtool
    ];
  };

  # # 系统级环境变量设置
  # environment.sessionVariables = {
  #   GTK_IM_MODULE = "fcitx";
  #   QT_IM_MODULE = "fcitx";
  #   XMODIFIERS = "@im=fcitx";
  #   SDL_IM_MODULE = "fcitx";
  # };

  # 配置 Nix 的 channels
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  };


  # 用户
  users.users.sigma = {
    isNormalUser = true;
    shell = pkgs.zsh;
    createHome = true;
		extraGroups = [ "wheel" "networkmanager" "docker" ]; # 允许用户使用 sudo
    packages = with pkgs; [              # 默认安装的用户包
      git
      vim
      wget
    ];
  };

  # 启用 sudo
  security.sudo.enable = true;
  services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];
  services.getty.autologinUser = "sigma";

  #services.displayManager.sddm.enable = true;
  #services.displayManager.startx.enable = true;

  systemd.services.NetworkManager.enable = true;
  networking.networkmanager.enable = true;

  # 启用 SSH 服务

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

  # 防火墙
  networking.firewall.enable = false;

  # 启用打印服务
  services.printing.enable = true;


  services.flatpak.enable = true;

  # 启用开机自动更新
  # system.autoUpgrade.enable = true;
  # hardware.nvidia.enable = true;

  # 系统环境变量

  environment.variables.EDITOR = "nvim";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
  };

  security.rtkit.enable = true;

  # enable gvfs for new morden function
  services.gvfs.enable = true;

  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
            thunar-media-tags-plugin
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # substituters = [
      #   "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      #   "https://mirrors.ustc.edu.cn/nix-channels/store"
      #   "https://cache.nixos.org/"
      # ];
      trusted-users = ["root" "sigma" "lawrence"];
    };
  };


  system.stateVersion = "24.11"; # Did you read the comment?
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" ];
}

