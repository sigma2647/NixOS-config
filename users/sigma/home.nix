{ config, pkgs, inputs, ... }:

{
# { pkgs, hostnames, ... }: {
  home.stateVersion = "24.11"; # 请根据实际版本设置
  imports = [
    ../../home/core.nix
    ../../home/shell
    ../../home/cli/lf
    ../../home/cli/yazi
    ../../home/kitty
    ../../home/pyprland
    ../../home/waybar
    ../../home/rofi
    ../../home/git
    # ../../home/fcitx5
    # ../../home/hyprland/hyprland.nix

  ];

  home.packages = with pkgs; [
    tealdeer
    bat
    # tree
    pyprland
    # obsidian
    btop
    cmatrix
    pipx
    uv
    xonsh
    zathura
    lan-mouse
    # texlive.combined.scheme-full
    # texstudio
    # inputs.ghostty.packages.x86_64-linux.default
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


}
