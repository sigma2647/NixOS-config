{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ttyper
    typioca
  ];
}
