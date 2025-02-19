{
  description = "Lawrence's config";

  nixConfig = {

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # 上海交大 
      "https://mirrors.bfsu.edu.cn/nix-channels/store"  # 北外
      "https://nix-community.cachix.org"
    ];
    trusted-users = [ "root" "lawrence" "sigma" ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs/nixos-24.11.git?shallow=1";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachix.url = "github:cachix/cachix";
    # ghostty = {
    #   url = "github:ghostty-org/ghostty";
    # };
  };

  outputs = inputs @ { self, home-manager, nixpkgs, nixpkgs-unstable, ... }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs-unstable.lib.genAttrs supportedSystems;
      
      pkgsBySystem = forAllSystems (system: {
        stable = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      });



     mkSystem = { hostname, username, system ? "x86_64-linux", extraModules ? [] }: 
      let
        specialArgs = {
          inherit username hostname inputs;
          pkgs = pkgsBySystem.${system}.stable;
          pkgs-unstable = pkgsBySystem.${system}.unstable;
        };
      in
      nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          ./modules/base.nix
          {
            nix.settings = {
              auto-optimise-store = true;
              experimental-features = [ "nix-command" "flakes" ];
              # 并行构建任务数
              max-jobs = "auto";
              # 构建时使用硬链接而不是复制
              use-case-hack = true;
            };
            
            # 支持非 NixOS 编译的程序
            programs.nix-ld.enable = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = inputs // specialArgs;
              users.${username} = import ./users/${hostname}/home.nix;
            };
          }
        ] ++ extraModules;
      };


      hostnames = "foo";
      lib = nixpkgs.lib;

    in
  {

    # 配置 NixOS
    nixosConfigurations = {
      # "nix-home" = lib.mkHost "nix-home";

      nix-home = let
        username = "sigma";
        specialArgs = {
          inherit username
                  hostnames
                  inputs;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./hosts/nix-home/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/nix-home/home.nix;
              _module.args.inputs = inputs;
            }
        ];
      };
      nix-gpd = let
        username = "lawrence";
        specialArgs = {
          inherit username
                  hostnames
                  inputs;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./hosts/nix-gpd/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/nix-gpd/home.nix;
              _module.args.inputs = inputs;
            }
        ];
      };

      jy-vm-nix = mkSystem {
        hostname = "jy-vm-nix";
        username = "lawrence";
      };

      # jy-vm-nix = let
      #   username = "lawrence";
      #   specialArgs = {
      #     inherit username
      #             hostnames;
      #   };
      # in
      #   nixpkgs.lib.nixosSystem {
      #     inherit specialArgs;
      #     system = "x86_64-linux";
      #   modules = [
      #     ./hosts/jy-vm-nix/configuration.nix

      #     home-manager.nixosModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.backupFileExtension = "backup";

      #       home-manager.extraSpecialArgs = inputs // specialArgs;
      #       home-manager.users.${username} = import ./users/jy-vm-nix/home.nix;
      #     }

      #   ];
      # };

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
        specialArgs = {
          inherit username
                  hostnames
                  inputs;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
        modules = [
          ./hosts/jy-alien/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs = inputs // specialArgs;
            home-manager.users.${username} = import ./users/jy-alien/home.nix;
            _module.args.inputs = inputs;
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
