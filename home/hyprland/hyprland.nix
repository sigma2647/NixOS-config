{ config, lib, pkgs, ... }:

{
  imports = [
    ../waybar/
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    # settings = {
    #   "$termianl" = "kitty";
    #   "$fileManager" = "$terminal -e sh -c 'yazi'";
    #   "$fileManager" = "thunar";
    #   "$mainMod" = "SUPER";

    #   monitor = ",preferred,auto,auto";

    #   monitor = ",preferred,auto,auto";
    #   monitor = ",preferred,auto,auto";

    #   exec-once = ",preferred,auto,auto";
    #   exec-once = "waybar";

    #   bind = "$mainMod, h, movefocus, l";
    #   bind = "$mainMod, l, movefocus, r";
    #   bind = "$mainMod, k, movefocus, u";
    #   bind = "$mainMod, j, movefocus, d";


    # }




    xwayland = { enable = true; };
    systemd.enable = true;
  };
}
