# modules/base.nix
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mihomo-party
    clash-verge-rev
  ];
}
