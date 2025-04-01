{ config, lib, pkgs, ... }:

{
  imports = [
    ./shares/public.nix
    ./shares/data.nix
  ];

  # 基础 Samba 服务配置
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
        workgroup = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "guest account" = "samba-guest";
        "map to guest" = "bad user";
      };
    };
  };

  # 防火墙配置
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };
}
