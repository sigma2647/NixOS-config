# modules/base.nix
{ config, lib, pkgs, ... }:
{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    use-case-hack = true;
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # 上海交大 
      "https://mirrors.bfsu.edu.cn/nix-channels/store"  # 北外
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  
  # 支持非 NixOS 编译的程序
  programs.nix-ld.enable = true;

  # home-manager 基础配置
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}
