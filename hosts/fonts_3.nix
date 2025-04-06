{ config, pkgs, pkgs-unstable, lib, ... }:

{
  fonts = {
     packages = with pkgs; [
       fira-code-nerdfont
       noto-fonts-cjk-sans
       noto-fonts-cjk-serif
       noto-fonts-emoji
     ];
     fontconfig = {
       antialias = true;
       hinting.enable = true;
       defaultFonts = {
         emoji = [ "Noto Color Emoji" ];
         monospace = [ "FiraCode Nerd Font" ];
         sansSerif = [ "Noto Sans CJK SC" ];
         serif = [ "Noto Serif CJK SC" ];
      };
    };
  };
}
