{
  programs.kdeconnect.enable = true;
  networking.firewall.allowedTCPPortRanges = [
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 1714; to = 1764; }
  ];

  environment.systemPackages = with pkgs; [
    kdeconnectgtk  # 包含indicator
  ];
}


# kdeconnect-app & # 图形界面
# kdeconnect-cli  # 命令行工具
