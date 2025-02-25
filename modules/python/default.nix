{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./tools.nix
    ./development.nix
  ];
}

