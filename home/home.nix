{ config, pkgs, ... }:

{
  home.stateVersion = "23.05"; # 请根据实际版本设置

  home.username = "lawrence";
  home.homeDirectory = "/Users/lawrence";

  home.packages = with pkgs; [
    git
    vim
    zsh
  ];

  # programs.zsh.enable = true;
}
