{config, lib, pkgs, pkgs-unstable,...}:
{
  # 添加内核模块支持
  boot.kernelModules = [
    "iptable_filter"
    "iptable_nat"
    "nf_nat"
    "nf_conntrack"
    "nf_conntrack_netlink"
    "xt_mark"
  ];

  # 启用 nftables
  networking.nftables.enable = true;

  # 原有的 tailscale 配置
  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    useRoutingFeatures = "both";
  };
  services.nftables.enable = true;

  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  systemd.services.tailscale = {
    after = [ "network-online.target"];
    wants = [ "network-online.target"];
    wantedBy = [ "multi-user.target"];
  };
}
