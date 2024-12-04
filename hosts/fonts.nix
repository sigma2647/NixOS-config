{ config, pkgs, lib, ... }:

{
  # Fonts
  #fonts.packages = with pkgs; [
  #  jetbrains-mono
  #];

  # Font`s
  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome
      # nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}

