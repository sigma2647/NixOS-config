{ pkgs, ... }: {
# { pkgs, hostnames, ... }: {
  home.stateVersion = "24.11"; # 请根据实际版本设置
  imports = [
    # ../../home/core.nix
    # ../../home/shell
    # ../../home/lf
    # ../../home/yazi/yazi.nix
    # ../../home/kitty
    # ../../home/pyprland
    # ../../home/waybar
    # ../../home/rofi
    # ../../home/fcitx5
    # ../../home/hyprland/hyprland.nix
    ../../home/cli/bash
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
    devenv
    traceroute
  ];
  programs.git = {
    enable = true;
    userName = "sigma2647";
    userEmail = "1169446204@qq.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
