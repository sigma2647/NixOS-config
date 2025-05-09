{ config, pkgs, system, pkgs-unstable, inputs, username, hostname, lib, ... }:

{

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
    ../../home/git
  ] ++ (if system == "aarch64-darwin" then [
    # macOS specific imports
    # ../../home/darwin/default.nix
  ] else []);
  
  home.username = username;
  home.homeDirectory = if system == "x86_64-linux" then "/home/${username}" else "/Users/${username}";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Set zsh as default shell
  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;
  #   shellAliases = {
  #     ll = "ls -l";
  #     la = "ls -la";
  #   };
  # };

  # Set zsh as default shell
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.packages = with pkgs-unstable; [
    # tealdeer
    # bat
    # tree
    # btop
    # cmatrix
    lazygit
    starship
    neovim
    zoxide
    # ncurses
    # cachix
    gping
    dufs
    proxychains-ng
    # devenv
  ] ++ (if system == "x86_64-linux" || system == "aarch64-linux" then [
    traceroute
  ] else []) ++ (if system == "aarch64-darwin" && (builtins.tryEval hostname).value == "mini" then [
    # macOS specific packages for mini
    # Add your macOS specific packages here
  ] else []);

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # macOS specific configurations
  home.activation = if system == "aarch64-darwin" && (builtins.tryEval hostname).value == "mini" then {
    # Add macOS specific activation scripts here
  } else {};

  # home.file.".config/bat".source = /home/${username}/dotfile/arch/install.sh;
  # home.file.".config/bat".source = "${config.home.homeDirectory}/dotfile/arch/install.sh";

}
