{ config, pkgs, ... }:

{
  home.stateVersion = "24.11"; # 请根据实际版本设置

  home.username = "lawrence";
  home.homeDirectory = "/Users/lawrence";

  home.packages = with pkgs; [
    git
    vim
    neovim
    zsh
    btop
    lf
    lazygit
    fish
    starship
    stow
    zoxide
    home-manager
    direnv
    fish

    ripgrep
    fzf
    yazi

    bat
    pyenv
    tmux
    tealdeer
    neovide
    tmux
    python3
    pdm
    uv
    pipx
  ];

  home.sessionVariables = {
    EDITOR = "nvim";  # 将 "neovim" 更改为其可执行文件名称
  };


  # programs.fish.enable = true;
  # programs.fish.enable = true;
  imports = [
    ../yazi/yazi.nix
  ];
}
