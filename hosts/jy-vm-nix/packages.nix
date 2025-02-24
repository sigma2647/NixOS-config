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

    tmux
    curl
    zoxide

    python3
    python3Packages.numpy
    blas
    lapack
    stdenv.cc.cc.lib

    uv
    ripgrep
    fd

    firefox


    file # should bulitin
    gcc
    libz
    gcc-unwrapped

  ];
}
