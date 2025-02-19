# modules/base.nix
{ config, lib, pkgs, ... }:
{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    use-case-hack = true;
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
