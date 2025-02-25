# modules/cachix.nix
{ config, lib, pkgs, ... }:

{
  # 配置Cachix
  services.cachix-agent = {
    enable = true;
  };

  # 如果您有私有Cachix缓存，可以添加到这里
  nix.settings = {
    substituters = lib.mkAfter [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = lib.mkAfter [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment.systemPackages = with pkgs; [
    cachix
  ];
}
