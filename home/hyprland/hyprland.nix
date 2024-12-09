{pkgs, ...}: let


in {
  imports = [
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor=,preferred,auto,auto

        $terminal = kitty
        $menu = wofi --show drun
        $fileManager = thunar

        bind = alt,backslash,exec,pypr toggle term && hyprctl dispatch bringactivetotop

        # bind=SUPER,F,exec,if hyprctl clients | grep scratch_yazi; then echo "scratch_yazi respawn not needed"; else kitty --class scratch_yazi -e yazi; fi
        # bind=SUPER,F,togglespecialworkspace,scratch_yazi

        # windowrulev2 = workspace special:term,class:^(scratch_yazi)$
        # windowrulev2 = float,class:^(scratch_yazi)$



        $scratchpadsize = size 80% 85%
        $scratchpad = class:^(scratchpad)$

        windowrulev2 = float,$scratchpad
        windowrulev2 = $scratchpadsize,$scratchpad
        # windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
        windowrulev2 = workspace special slient,$scratchpad
        windowrulev2 = center,$scratchpad


        $scratchpadsize = size 80% 85%
        $scratchpad = class:^(term)$

        windowrulev2 = float,$scratchpad
        windowrulev2 = $scratchpadsize,$scratchpad
        # windowrulev2 = bordersize 0, floating:0, onworkspace:w[t1]
        windowrulev2 = workspace special slient,$scratchpad
        windowrulev2 = center,$scratchpad
      ''
    }
    xwayland = { enable = true; };
    systemd.enable = true;
  ]
}
