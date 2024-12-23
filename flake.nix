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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs/nixos-24.11.git?shallow=1";

    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, ... } @inputs:
    let
      hostnames = "foo";
      systems = {
        linux = [ "x86_64-linux" "aarch64-linux" ];
        darwin = [ "aarch64-darwin" "x86_64-darwin" ];
      };

      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      
      # 创建 overlay 使 unstable 包在全局可用
      overlay-unstable = final: prev: {
        unstable = pkgs-unstable;
      };


      forAllSystems = f: nixpkgs.lib.genAttrs (systems.linux ++ systems.darwin) f;
      # lib = nixpkgs.lib;

      pkgsFor = system: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };

        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      pkgsForSystem = system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      lib = {
        mkHost = { hostname, system, username, extraModules ? [] }: 
          let
            # 创建该系统架构的 unstable 包集合
            unstable = pkgsForSystem system;
          in nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./hosts/${hostname}/configuration.nix
              
              # 注入 unstable 包到模块中
              ({ pkgs, ... }: {
                nixpkgs.overlays = [
                  (final: prev: {
                    # 将 unstable 包加入到 pkgs 中
                    unstable = unstable;
                  })
                ];
              })
              
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = import ./home/${hostname}.nix;
              }
              
              ./modules/common.nix
              ./hosts/${hostname}/hardware-configuration.nix
            ] ++ extraModules;
            
            specialArgs = { 
              inherit inputs system username unstable; 
            };
          };
      };

    in
  {

    # 配置 NixOS
    nixosConfigurations = {
      "nix-home" = lib.mkHost "nix-home";

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
              home-manager.backupFileExtension = "backup";

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
        ];
      };

      nix-lab = let
        username = "lawrence";
        specialArgs = {
          inherit username
                  hostnames;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
        modules = [
          ./hosts/nix-lab/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./users/nix-lab/home.nix;
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
