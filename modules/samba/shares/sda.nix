{ config, lib, pkgs, ... }:

{
  services.samba.settings = {
    public = {
      "path" = "/mnt/sda/Public";
      "browseable" = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
    };
  };
}
