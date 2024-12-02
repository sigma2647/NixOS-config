# # {config, username, ...}: {
# {config, pkgs, username, ...}: {
#   # Home Manager needs a bit of information about you and the
#   # paths it should manage.
#   home = {
#     inherit username;
#     homeDirectory = "/home/${username}";
# 
#     # This value determines the Home Manager release that your
#     # configuration is compatible with. This helps avoid breakage
#     # when a new Home Manager release introduces backwards
#     # incompatible changes.
#     #
#     # You can update Home Manager without changing this value. See
#     # the Home Manager release notes for a list of state version
#     # changes in each release.
#     stateVersion = "24.11";
#   };
# 
#   # Let Home Manager install and manage itself.
#   programs.home-manager.enable = true;
# }


{ config, pkgs, ... }:

{
  home.stateVersion = "24.11"; # 请根据实际版本设置

# home.username = "sigma";
# home.homeDirectory = "/home/sigma";

# home.packages = with pkgs; [
#   git
#   vim
#   neovim
#   zsh
#   btop
#   direnv
#   lf
#   lazygit
#   fish
#   starship
#   stow
#   zoxide
#   home-manager
#   fish
#   tmux
#   tealdeer
#   bat
#   tmux
#   ripgrep



#   python312
#   uv
#   pyenv
#   pipx
# ];

# home.sessionVariables = {
#   EDITOR = "nvim";  # 将 "neovim" 更改为其可执行文件名称
# };


# # programs.fish.enable = true;
# programs.direnv.nix-direnv.enable = true;
}
