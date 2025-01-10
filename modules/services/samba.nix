{
  pkgs,
  ...
}:

{
  services.samba = {
    enable = true;
    openFirewall = true;    # 是否打开防火墙端口
    settings = {
      global = {
        security = "user";         # 安全级别
        workgroup = "WORKGROUP";  # 工作组名称
        "server string" = "smbnix";  # 服务器描述
        "netbios name" = "smbnix";   # NetBIOS 名称
        # "guest account" = "nobody";  # 客户端访问时使用的账户
        "guest account" = "samba-guest";  # 使用新的访客账户
        "map to guest" = "bad user"; # 当用户登录失败时映射到 guest 用户
        # "hosts allow" = "192.168.15. 127.0.0.1 localhost 100.64.0.0/10";  # 允许访问的 IP 地址范围
      };
      public = {
        "path" = "/mnt/Shares/Public";  # 共享目录路径
        "browseable" = "yes";           # 是否可浏览
        "read only" = "no";             # 是否只读
        "guest ok" = "no";             # 是否允许匿名访问
        "create mask" = "0644";         # 创建文件的权限掩码
        "directory mask" = "0755";      # 创建目录的权限掩码
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 139 445 ];  # 允许 TCP 端口
    allowedUDPPorts = [ 137 138 ];  # 允许 UDP 端口
  };
}
