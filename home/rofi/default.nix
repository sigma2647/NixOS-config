{ config, lib, pkgs, ... }:

{
  wayland.windowManager.rofi = {
    enable = true;
  };
}
