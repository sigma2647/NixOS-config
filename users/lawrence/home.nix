{ config, pkgs, inputs, username, ... }:

{
  home = {
    username = "lawrence"; # 替换为你的用户名
    homeDirectory = "/home/lawrence"; # Linux 路径，macOS 用 "/Users/your-username"

    stateVersion = "24.11"; # 保持与 Home Manager 版本一致
  };

  imports = [
    # ../../home/core.nix
    # ../../home/shell
    # ../../home/lf
    ../../home/cli/yazi
    # ../../home/kitty
    # ../../home/pyprland
    # ../../home/waybar
    # ../../home/rofi
    # ../../home/fcitx5
    # ../../home/hyprland/hyprland.nix
    # ../../home/cli/bash
    # ../../home/git
  ];

  # home.packages = with pkgs; [
  #   # tealdeer
  #   # bat
  #   # tree
  #   # btop
  #   # cmatrix
  #   lazygit
  #   # starship
  #   # ncurses
  #   # cachix
  #   # devenv
  #   traceroute
  # ];

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  # };

  # home.file.".config/bat".source = /home/${username}/dotfile/arch/install.sh;
  # home.file.".config/bat".source = "${config.home.homeDirectory}/dotfile/arch/install.sh";

}
