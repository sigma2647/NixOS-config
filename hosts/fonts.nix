{ config, pkgs, lib, ... }:

{
  # Fonts
  #fonts.packages = with pkgs; [
  #  jetbrains-mono
  #];

  # # Font`s
  # fonts = {
  #   packages = with pkgs; [
  #     material-design-icons
  #     font-awesome
  #     # nerd-fonts.fira-code
  #     nerd-fonts.jetbrains-mono
  #   ];
  # };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
}

