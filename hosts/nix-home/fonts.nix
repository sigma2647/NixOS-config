{ pkgs, ... }:

{
  # Fonts
  #fonts.packages = with pkgs; [
  #  jetbrains-mono
  #];
  font.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
}

