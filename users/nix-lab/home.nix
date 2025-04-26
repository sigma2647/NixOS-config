{ pkgs, ... }: {
# { pkgs, hostnames, ... }: {
  home.stateVersion = "24.11"; # 请根据实际版本设置
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
    ../../home/cli/bash
    ../../home/git
  ];

  home.packages = with pkgs; [
    tealdeer
    bat
    # tree
    btop
    cmatrix
    pipx
    uv
    yazi
    lazygit
    starship
    # devenv
    traceroute
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
