{

  description = "Lawrence's config";
  
  inputs = {

    # nixpkgs.url = "https://github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-chanels/nixos-24.05/nixexprs.tar.xz";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-chanels/nixpkgs-unstable/nixexprs.tar.xz";

  };


  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      nixos-home = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ hosts/nix-home/configuration.nix ];
      };
    };
  };
}



