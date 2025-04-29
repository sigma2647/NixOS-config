{ config, pkgs, inputs, username, ... }:

{
  home.stateVersion = "24.11"; # 请根据实际版本设置
  imports = [
    ../../home/core.nix
    # ../../home/shell
    # ../../home/lf
    ../../home/cli/yazi
    # ../../home/kitty
    # ../../home/pyprland
    # ../../home/waybar
    # ../../home/rofi
    # ../../home/fcitx5
    # ../../home/hyprland/hyprland.nix
    ../../home/cli/bash
    ../../home/git
  ];

  home.packages = with pkgs; [
    # tealdeer
    # bat
    # tree
    btop
    cmatrix
    lazygit
    starship
    ncurses
    # cachix
    # devenv
    traceroute
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # home.file.".config/bat".source = /home/${username}/dotfile/arch/install.sh;
  # home.file.".config/bat".source = "${config.home.homeDirectory}/dotfile/arch/install.sh";

}
