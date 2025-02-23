{ config, pkgs, lib, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      font-awesome
      maple-mono  # Use maple-mono package instead
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Times New Roman" ];
        sansSerif = [ "Arial" ];
        monospace = [ "JetBrainsMono Nerd Font" "Maple Mono" ];
      };
    };
  };
}
