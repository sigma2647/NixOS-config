{config, username, ...}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username; # 替换为你的用户名
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}


