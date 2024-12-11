{ config, pkgs, ... }:

{
  home.stateVersion = "24.11"; # 请根据实际版本设置

  home.username = "lawrence";
  home.homeDirectory = "/home/lawrence";

  home.packages = with pkgs; [
    git
    vim
    neovim
    zsh
    btop
    direnv
    lf
    lazygit
    fish
    starship
    stow
    zoxide
    home-manager
    fish
    tmux
    tealdeer
    bat
    tmux
    ripgrep



    python312
    uv
    pyenv
    pipx
    tailscale
  ];

  home.sessionVariables = {
    EDITOR = "nvim";  # 将 "neovim" 更改为其可执行文件名称
  };


  # programs.fish.enable = true;
  imports = [
    ../yazi/yazi.nix
  ];

}
