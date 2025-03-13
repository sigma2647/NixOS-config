{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        data-root = "/var/lib/docker";
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
