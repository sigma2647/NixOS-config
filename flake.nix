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
    trusted-users = [ "root" "lawrence" "sigma" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs/nixos-24.11.git?shallow=1";

    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, ... } @inputs:
    let
      hostnames = "foo";
      systems = {
        linux = [ "x86_64-linux" "aarch64-linux" ];
        darwin = [ "aarch64-darwin" "x86_64-darwin" ];
      };
      forAllSystems = f: nixpkgs.lib.genAttrs (systems.linux ++ systems.darwin) f;
      lib = nixpkgs.lib;
      users = import ./lib/users.nix;
      mkHost = { system ? "x86_64-linux"
               , hostname
               , username ? users.mainUser
               , extraModules ? []
               }: 
        lib.nixosSystem {
          inherit system;
          specialArgs = { 
            inherit inputs system hostname username; 
          };
          modules = [
            # 基础配置
            ./hosts/default.nix
            # 特定主机配置
            # ./hosts/${hostname}
            # home-manager
            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs // { inherit hostname username; };
                users.${username} = import ./home/linux/home.nix;
              };
            }
          ] ++ extraModules;
        };
    in
  {

    # 配置 NixOS
    nixosConfigurations = {
      nix-home = let
        username = "sigma";
        specialArgs = {
          inherit username
                  hostnames;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
        modules = [
          ./hosts/nix-home
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./users/${username}/home.nix;
          }
        ];
      };

      jy-alien = let
        username = "sigma";
        specialArgs = {inherit username;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
        modules = [
          ./hosts/jy-alien
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./users/${username}/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      darwin = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
        };
        modules = [
          ./home/darwin/home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };

      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
        modules = [
          ./home/linux/home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

  };
}
