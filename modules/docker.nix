{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
      daemon.settings = {
        data-root = "/etc/docker";
        registry-mirrors = [ 
          "https://docker.m.daocloud.io"
          "https://docker.imgdb.de"
          "https://docker-0.unsee.tech"
          "https://docker.hlmirror.com"
          "https://docker.1ms.run"
          "https://func.ink" 
       ];
      };
    };
    libvirtd.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    docker-compose
    docker-client
  ];


  
  # 确保相关用户服务也启用
  systemd.user.services.docker.wantedBy = [ "default.target" ];
}
