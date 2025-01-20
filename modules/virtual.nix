{ pkgs, ... }:
{

  programs.virt-manager = {
    enable = true;
    package = pkgs.virt-manager;
  };
}
