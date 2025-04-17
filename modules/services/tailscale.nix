{config, lib, pkgs, pkgs-unstable,...}:
{
  
  services.tailscale = {
    enable = true;
    # package = pkgs-unstable.tailscale;
    package = pkgs-unstable.tailscale;
    useRoutingFeatures = "both";
    acceptRoutes = true;
  };


  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
  };
  #  // (if config.networking.hostName != "jeffhyper" then {} else {
  #   systemd.services.tailscale.serviceConfig.Environment = [
  #     "PORT=${config.services.tailscale.port}"
  #     "FLAGS=--exit-node=192.168.1.200"
  #   ];
  # })
  
}

