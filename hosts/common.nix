{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dig
  ];
}
