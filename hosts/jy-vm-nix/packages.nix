{ config, pkgs, pkgs-unstable, lib, ... }:
{
  # 基础系统工具
  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
    git
    vim
    pkgs-unstable.neovim
    # pkgs-unstable.python313Packages.markitdown
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

    proxychains-ng
    pkgs-unstable.python313Packages.markitdown
    taskwarrior3
    fastfetch
    httpie
  ];
}
