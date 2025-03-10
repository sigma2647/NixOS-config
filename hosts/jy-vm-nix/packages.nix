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



    
    openssh
    zoxide

    btrfs-progs
    compsize
    stdenv.cc.cc.lib
    ffmpeg
    # iptables




    tmux
    curl

    blas
    lapack

    ripgrep
    fd

    firefox


    file # should bulitin
    gcc
    libz
    gcc-unwrapped

    dufs
    emacs30

  ];
}
