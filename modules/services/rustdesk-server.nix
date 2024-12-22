{ config, pkgs, ... }:

{
  # 开放必要的端口
  networking.firewall = {
    allowedTCPPorts = [ 21115 21116 21117 21118 21119 ];
    allowedUDPPorts = [ 21116 ];
  };

  # 创建系统用户
  users.users.rustdesk = {
    isSystemUser = true;
    group = "rustdesk";
    description = "RustDesk Server user";
    home = "/var/lib/rustdesk-server";
    createHome = true;
  };

  users.groups.rustdesk = {};

  # 添加 RustDesk 服务器包
  environment.systemPackages = with pkgs; [
    rustdesk-server
  ];

  # 配置 RustDesk 服务
  systemd.services.rustdesk-server = {
    description = "RustDesk Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "simple";
      User = "rustdesk";
      Group = "rustdesk";
      ExecStart = "${pkgs.rustdesk-server}/bin/rustdesk-server";
      WorkingDirectory = "/var/lib/rustdesk-server";
      Restart = "always";
      RestartSec = "10s";
    };
  };

  # 创建必要的目录
  system.activationScripts = {
    rustdesk-server-dir = {
      text = ''
        mkdir -p /var/lib/rustdesk-server
        chown rustdesk:rustdesk /var/lib/rustdesk-server
        chmod 755 /var/lib/rustdesk-server
      '';
      deps = [];
    };
  };
}
