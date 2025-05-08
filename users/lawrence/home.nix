{ config, pkgs, system, pkgs-unstable, inputs, username, ... }:

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
  ];
  
  home.username = username;
  home.homeDirectory = if system == "x86_64-linux" then "/home/${username}" else "/Users/${username}";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Set zsh as default shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
    };
  };

  # Set zsh as default shell
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.packages = with pkgs-unstable; [
    # tealdeer
    # bat
    # tree
    # btop
    cmatrix
    lazygit
    # starship
    # ncurses
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
