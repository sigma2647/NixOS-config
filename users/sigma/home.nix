{ pkgs, ... }: {
  home.stateVersion = "24.11"; # 请根据实际版本设置
  imports = [
    ../../home/core.nix
    ../../home/shell
  ];

  programs.git = {
    enable = true;
    userName = "sigma2647";
    userEmail = "1169446204@qq.com";
  };
}
