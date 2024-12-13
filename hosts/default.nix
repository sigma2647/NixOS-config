{ config, lib, pkgs, ... }:

{
  # 基础系统设置

  time.timeZone = lib.mkDefault "Asia/Shanghai";  # 允许覆盖
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };
  
  # Nix 设置
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];  # 更通用的配置
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;  # 默认启用防火墙
  };


  # 基础安全设置
  security = {
    sudo.enable = true;
    rtkit.enable = true;
  };

  # 核心服务
  services = {
    openssh.enable = lib.mkDefault true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # 基础环境变量
  environment = {
    
    # 基础系统包
    systemPackages = with pkgs; [
      # 基础工具
      vim
      git
      wget
      curl
      tree
      
      # 终端工具
      tmux
      zsh
      zoxide
      direnv
      ripgrep
      bat
      
    ];
  };

  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store/" ];

  system.stateVersion = "24.11";
}
