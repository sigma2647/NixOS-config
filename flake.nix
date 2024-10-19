{

  description = "Lawrence's config";

  nixConfig = {
    # substituters = [
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://cache.nixos.org/"
    # ];
    #
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store/"
      "https://cache.nixos.org/"
    ];
  };

  inputs = {
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixpkgs.url = "https://github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-chanels/nixpkgs-unstable/nixexprs.tar.xz";
    ## nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.05/nixexprs.tar.xz";
    home-manager.url = "github:nix-community/home-manager";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
  };


  # outputs = { self, home-manager, nixpkgs, ... }@inputs:
  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      inherit (self) outputs;
      systems = [
          "aarch64-linux"
          "i686-linux"
          "x86_64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      nixosConfigurations = {
        # hosts
        nix-home = lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/nix-home
          ];
        };
        jy-alien = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # hosts/nix-home/configuration.nix
            ./hosts/jy-alien
	    # home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}

