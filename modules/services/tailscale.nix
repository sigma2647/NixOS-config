{config, lib, pkgs, ...}:

{
  services.tailscale = {
	  enable = true;
	  package = pkgs.tailscale;
	  useRoutingFeatures = "both";
  };

  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}
