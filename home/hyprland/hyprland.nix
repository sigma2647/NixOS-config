{ config, lib, pkgs, ... }:

{
  imports = [
    ../waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$termianl" = "kitty";
      # "$fileManager" = "$terminal -e sh -c 'yazi'";
      "$fileManager" = "thunar";
      "$mainMod" = "SUPER";
      "$menu" = "wofi --show drun";

      monitor = ",preferred,auto,auto";


      exec-once = "waybar";
      exec-once = "pypr";
      exec-once = "swww-daemon";
      # exec-once = "mako";


      bind = "$mainMod, h, movefocus, l";
      bind = "$mainMod, l, movefocus, r";
      bind = "$mainMod, k, movefocus, u";
      bind = "$mainMod, j, movefocus, d";

      bind = "alt,backslash,exec,pypr toggle term && hyprctl dispatch bringactivetotop";
      bind = "$mainMod, Space, exec, pkill rofi || rofi -show drun";


      # env = 

      env = XCURSOR_SIZE,24;
      env = HYPRCURSOR_SIZE,24;


      windowrule = "pseudo, fcitx";
      


    }




    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
