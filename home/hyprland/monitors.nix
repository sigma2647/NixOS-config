# hosts/modules/hyprland/monitors.nix
{ lib, hostname, ... }:
let
  # 不同主机的显示器配置
  monitors = {
    "nix-home" = ''
      monitor=,3440x1440@100,auto,1
    '';
    
    "laptop" = ''
      monitor=eDP-1,1920x1080@60,auto,1
      monitor=,preferred,auto,1  # 外接显示器自动配置
    '';
    
    "work" = ''
      monitor=DP-1,2560x1440@165,auto,1
    '';
  };
in {
  wayland.windowManager.hyprland.extraConfig = 
    monitors.${hostname} or  # 使用主机特定配置
    "monitor=,preferred,auto,1";  # 默认配置
}
