# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  inputs,
  system,
  config,
  pkgs,

  username,
  fullname,
  ...
}:

{
  imports = [
    ./gtk.nix
    ./appimage.nix
    ./nix.nix
    ./boilerplate.nix
    ./bootloader.nix
    ./env-vars.nix
  ];

  # Kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${fullname}";
    extraGroups = ["networkmanager" "wheel" "video" "kvm"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #### Core Packages
    lld
    gcc
    glibc
    clang
    udev
    llvmPackages.bintools
    wget
    procps
    killall
    zip
    unzip
    bluez
    bluez-tools
    libnotify
    brightnessctl
    light
    xdg-desktop-portal
    xdg-utils
    pipewire
    wireplumber
    alsaLib
    pkg-config

    #### Standard Packages
    networkmanager
    networkmanagerapplet
    git
    fzf
    vim
    tldr
    sox
    yad
    flatpak
    ffmpeg

    #### GTK
    gtk2
    gtk3
    gtk4

    #### QT
    #qtcreator
    qt5.qtwayland
    qt6.qtwayland
    qt6.qmake
    libsForQt5.qt5.qtwayland
    qt5ct

    #### My Packages
    helix
    brave
    xfce.thunar
    bat
    eza
    pavucontrol
    blueman
    #trash-cli
    ydotool
    cava
    neofetch
    cpufetch
    starship
    lolcat
    gimp
    transmission-gtk
    slurp
    gparted
    vlc
    mpv
    krabby
    zellij
    shellcheck
    thefuck
    gthumb
    cmatrix
    lagrange
    lavat

    #### My Proprietary Packages
    discord
    steam

    #### Xorg Stuff :-(
    ## Libraries
    xorg.libX11
    xorg.libXcursor
    ## Window Managers
    #awesome
    ## Desktop Environments
    cinnamon.cinnamon-desktop
    ## Programs
    #nitrogen
    #picom
    #dunst
    #flameshot

    #### Programming Languages
    ## Rust
    cargo
    rustc
    rustup
    rust-analyzer
    ## Go
    go
    ## R
    (pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        dplyr
        xts
        ggplot2
        reshape2
      ];
    })
    (pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [
        dplyr
        xts
        ggplot2
        reshape2

        rstudioapi
      ];
    })

    #### Command Shells
    nushell

    #### Display Managers
    lightdm
    sddm
    gnome.gdm

    #### Hyprland Rice
    hyprland
    waybar
    xwayland
    cliphist
    alacritty
    rofi-wayland
    swww
    swaynotificationcenter
    lxde.lxsession
    inputs.hyprwm-contrib.packages.${system}.grimblast
    gtklock
    eww-wayland
    xdg-desktop-portal-hyprland
  ];

  # Font stuff:
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # GTKLock
  security.pam.services.gtklock = {};

  # Steam
  programs.steam.enable = true;

  ## Enable some shit:
  # Programs
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  # Services
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    libinput.enable = true;
    displayManager.gdm = {
      enable = true;
    };
  };

  services.blueman.enable = true;
  services.flatpak.enable = true;
  ## ^

  # Xorg window managers:
  services.xserver.windowManager = {
    #awesome = {
    #  enable = true;
    #  luaModules = with pkgs.luaPackages; [
    #    luarocks
    #    luadbi-mysql
    #  ];
    #};
  };

  # Xorg desktop environments:
  services.xserver.desktopManager = {
    cinnamon.enable = true;
  };

  # Home manager options
  home-manager.users.${username} = {
    # programs.waybar = {
    #   enable = true;
    #   package = inputs.hyprland.packages.${system}.waybar-hyprland;
    # };
  };

  # Package overlays:
  nixpkgs.overlays = [
    (self: super: {
    })
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
