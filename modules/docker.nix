{ pkgs, ... }:

{
  # Docker Rootless 模式核心配置
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;  # 设置 DOCKER_HOST 环境变量
    };

    # 关键：使用官方文档指定的 daemon.settings
    daemon.settings = {
      registry-mirrors = [ 
        "https://docker.m.daocloud.io"
        "docker.imgdb.de"
        "https://docker-0.unsee.tech"
        "https://docker.hlmirror.com"
        "https://docker.1ms.run"
        "https://func.ink" 
      ];
    };
  };

  # 必须的用户命名空间配置
  users.users.lawrence = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # 用户级服务管理
  systemd.user.services.docker = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Environment = "DOCKERD_FLAGS=--config-file=${pkgs.writeText "daemon.json" (builtins.toJSON config.virtualisation.docker.daemon.settings)}";
    };
  };
}