{
  description = "Lawrence's config";

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/"
      "https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store/"
      "https://cache.nixos.org/"
    ];
    trusted-users = [ "root" "lawrence" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, home-manager, nixpkgs, ... }: 
  let
    lib = nixpkgs.lib;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = lib.genAttrs systems;
  in
  {
    homeConfigurations = {
      lawrence = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
        modules = [
          ./home/home.nix
        ];
      };
    };

    # 配置 NixOS
    nixosConfigurations = {
      nix-home = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nix-home
        ];
      };

      jy-alien = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/jy-alien
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
