{ config, lib, pkgs, ... }:

{
  imports = [
    ../waybar/
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$termianl" = "kitty";
      # "$fileManager" = "$terminal -e sh -c 'yazi'";
      "$fileManager" = "thunar";
      "$mainMod" = "SUPER";

      monitor = ",preferred,auto,auto";

      exec-once = "waybar";
      exec-once = "pypr";

      bind = "$mainMod, h, movefocus, l";
      bind = "$mainMod, l, movefocus, r";
      bind = "$mainMod, k, movefocus, u";
      bind = "$mainMod, j, movefocus, d";

      env = 

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24


    }




    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
