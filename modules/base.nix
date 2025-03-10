# modules/base.nix
{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/system/time.nix
  ];
  nix = {
    settings = {
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      fallback = true;
      log-lines = 25;  # 减少日志输出
      eval-cache = true;
      experimental-features = [ "nix-command" "flakes" ];
      max-jobs = "auto";
      use-case-hack = true;
      cores = 0;
      use-xdg-base-directories = true;
      # 开启二进制缓存压缩
      compress-build-log = true;
      # 自动清理过期的生成
      auto-optimise-store = true;
      substituters = [


        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org"

        # "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
        # "https://mirrors.cernet.edu.cn/nix-channels/store" # mirrorz
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
        # "https://mirror.sjtu.edu.cn/nix-channels/store"  # 上海交大 
        # "https://mirrors.bfsu.edu.cn/nix-channels/store"  # 北外
        # "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = ["root" "sigma" "lawrence"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d"; # 减少到14天
    };
  };
  
  # 支持非 NixOS 编译的程序
  programs.nix-ld.enable = true;
  services.cachix-agent.enable = true;

  # home-manager 基础配置
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
  environment.systemPackages = with pkgs; [
    ffmpeg
    git


    # mission-center
    # dufs  # python -m http.server
    # glance # A nice dashboard
    # cockpit
    
  ];
  services.fstrim.enable = true;
}
