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
    python3Packages.numpy
    blas
    lapack
    stdenv.cc.cc.lib

    uv
    ghostty
    rofi-wayland
    ripgrep
    fd
    swww

    firefox


    file # should bulitin
    gcc
    libz
    gcc-unwrapped

  ];
}
