{ config, lib, pkgs, ... }:

{
  services.tor.enable = true;
  services.tor.client.enable = true;
}
