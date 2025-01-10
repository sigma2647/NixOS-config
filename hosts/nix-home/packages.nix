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
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler # 缩略图支持
    papirus-icon-theme
    ffmpegthumbnailer
    gvfs
    adwaita-qt
    # ---




    python3
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

    emacs29-pgtk

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



  ];
}
