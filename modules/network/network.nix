{ config, pkgs, ...}:

{
  networking = {
    useDHCP = false;
    interfaces.ensfo = {
      ipv4.addresses = [
        { address = "192.168.1.113"; prefixLength = 24; }
      ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };
}
