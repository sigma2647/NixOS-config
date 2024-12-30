{
  description = "Lawrence's config";

  nixConfig = {

    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"  # 中科大
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # 上海交大 
      "https://mirrors.bfsu.edu.cn/nix-channels/store"  # 北外
      "https://nix-community.cachix.org"
    ];
    trusted-users = [ "root" "lawrence" "sigma" ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs/nixos-24.11.git?shallow=1";

    # nixpkgs.url = "https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11/nixexprs.tar.xz";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cachix.url = "github:cachix/cachix";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, ghostty, ... } @inputs:
    let
      hostnames = "foo";
      systems = {
        linux = [ "x86_64-linux" "aarch64-linux" ];
        darwin = [ "aarch64-darwin" "x86_64-darwin" ];
      };


      forAllSystems = f: nixpkgs.lib.genAttrs (systems.linux ++ systems.darwin) f;

      lib = nixpkgs.lib;

      # system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system}; # 使用 unstable
      # 
      # lib = {
      #   mkHost = hostname: nixpkgs-unstable.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ./hosts/${hostname}/configuration.nix
      #       
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.sigma = import ./home/${hostname}.nix;
      #         home-manager.users.${username} = import ./users/${username}/home.nix;
      #         # 添加这个来传递 inputs
      #         _module.args.inputs = inputs;
      #       }
      #       
      #       ./modules/common.nix
      #       ./hosts/${hostname}/hardware-configuration.nix
      #     ];
      #     specialArgs = { inherit inputs; }; # 确保这行存在
      #   };
      # };


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
              home-manager.users.${username} = import ./users/${username}/home.nix;
              _module.args.inputs = inputs;
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
