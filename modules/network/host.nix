{ config, pkgs, ...}:

{
  networking.extraHosts = ''
    100.74.252.119  nix-lab
    100.119.224.41  mini
    100.92.60.84    desktop-2ij6cg8
    100.101.26.120  iphone-15-pro-max
    100.125.108.10  mbp
    100.92.84.62    nix-home
  ''
}
