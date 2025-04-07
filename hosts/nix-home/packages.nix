{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    wget
    curl
    vscode
    tree

    tmux
    kitty
    lf
    lazygit

    fastfetch

    #(texlive.combine { inherit (texlive) scheme-full; })
    zsh
    starship
    zoxide
    pyenv
    direnv
    fzf

    ripgrep

    bat
    pstree
    nodejs

    nautilus
    # ---
    papirus-icon-theme
    gvfs
    adwaita-qt
    # ---




    wpgtk
    swww
    ffmpeg
    # zed
    # unstable.pywal16
    #
    gcc
    libffi
    openssl


    stow
    flatpak

    # zed-editor

    firefox

    # hyprland                   # 安装 Hyprland
    waybar                     # 可选: Wayland 状态栏
    rofi-wayland                       # 可选: 应用启动器
    wl-clipboard
    #dunst                      # 可选: 通知管理器




    networkmanager
    networkmanagerapplet
    openssh
    home-manager

    #gtk2
    #gtk3
    #gtk4

    emacs

    fcitx5-rime
    rime-data
    openvpn
    qemu
    virt-manager
    # quickemu


    # ---theme---
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors
    papirus-icon-theme


    python3
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
