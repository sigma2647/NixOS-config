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

    blas
    lapack
    stdenv.cc.cc.lib

    ripgrep
    fd

    firefox


    file # should bulitin
    gcc
    libz
    gcc-unwrapped

  ];
}
