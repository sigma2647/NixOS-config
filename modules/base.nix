# modules/base.nix
{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/system/time.nix
  ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    use-case-hack = true;
    # 开启二进制缓存压缩
    compress-build-log = true;
    # 自动清理过期的生成
    auto-optimise-store = true;
    use-xdg-base-directories = true;  # 减少Nix评估时的I/O操作
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store" # mirrorz
      "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # 上海交大 
      "https://mirrors.bfsu.edu.cn/nix-channels/store"  # 北外
      # "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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
    
  ];
  services.fstrim.enable = true;
}
