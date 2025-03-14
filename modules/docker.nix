{ pkgs, username,... }:

{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
      # 明确指定 rootless 模式的配置路径
      daemonConfig = {
        data-root = "/var/lib/docker";  # 保持与之前一致
        registry-mirrors = [ 
          "https://docker.m.daocloud.io",
          "https://docker.imgdb.de",
          "https://docker-0.unsee.tech",
          "https://docker.hlmirror.com",
          "https://docker.1ms.run",
          "https://func.ink" 
        ];
      };
    };
  };

  # 必须添加的权限配置
  users.users.${username} = {
    extraGroups = [ "docker" "libvirtd" ];
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # 确保用户级 systemd 能正确加载服务
  systemd.user.services.docker = {
    enable = true;
    wantedBy = [ "default.target" ];
  };
}