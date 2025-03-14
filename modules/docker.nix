{ pkgs, ... }:

{
  # Docker 虚拟化配置
  virtualisation = {
    # 启用 Docker 并配置 rootless 模式
    docker = {
      enable = true;
      rootless = {
        enable = true;          # 启用 rootless 模式
        setSocketVariable = true; # 设置 DOCKER_HOST 环境变量
      };

      # Docker 守护进程配置 (将合并到 /etc/docker/daemon.json)
      daemon.settings = {
        data-root = "/var/lib/docker";  # 自定义存储路径
        registry-mirrors = [            # 镜像加速列表
          "https://docker.m.daocloud.io"
          "https://docker.imgdb.de"
          "https://docker-0.unsee.tech"
          "https://docker.hlmirror.com"
          "https://docker.1ms.run"
          "https://func.ink" 
        ];
      };
    };

    # 可选：Libvirt 虚拟化支持
    libvirtd.enable = true;
  };

  # 系统环境包配置
  environment.systemPackages = with pkgs; [
    docker-compose    # Docker 编排工具
    docker-client     # Docker CLI 客户端
  ];

  # Rootless 模式用户服务配置
  systemd.user.services.docker = {
    wantedBy = [ "default.target" ];  # 随用户会话自动启动
  };

  # 用户权限配置 (替换 youruser 为实际用户名)
  # users.users.youruser = {
  #   extraGroups = [ "docker" "libvirtd" ];  # 加入 docker 和 libvirt 用户组
  # };
}