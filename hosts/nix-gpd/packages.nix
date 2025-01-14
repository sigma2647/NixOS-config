{ pkgs, ... }: {
  # 基础系统工具
  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
    git
    vim
    neovim
    wget
    stow

    networkmanager
    networkmanagerapplet
    openssh
    tmux
    curl
    zoxide

    python3
    uv
    ghostty
    rofi-wayland
    ripgrep
    fd
    swww

    firefox
  ];
}
