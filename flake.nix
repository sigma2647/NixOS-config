{
  description = "Lawrence's config";

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

    # cachix = {
    #   url = "github:cachix/cachix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

      assert lib.assertMsg (builtins.elem system supportedSystems) "Unsupported system: ${system}";

      nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          ./modules/base.nix
          {
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

      # Helper function for creating home-manager configurations
      mkHomeConfig = { system, configFile, extraModules ? [] }: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          configFile
        ] ++ extraModules;
        extraSpecialArgs = {
          inherit inputs;
          pkgs = pkgsBySystem.${system}.stable;
          pkgs-unstable = pkgsBySystem.${system}.unstable;
        };
      };

    in
  {

    # 配置 NixOS
    nixosConfigurations = {

      jy-vm-nix = mkSystem {
        hostname = "jy-vm-nix";
        username = "lawrence";
      };

      nix-home = mkSystem {
        hostname = "nix-home";
        username = "sigma";
      };

      nix-gpd = mkSystem {
        hostname = "nix-gpd";
        username = "lawrence";
      };

      nix-lab = mkSystem {
        hostname = "nix-lab";
        username = "lawrence";
      };

    };

    homeConfigurations = {
      # Darwin configurations
      "mini" = mkHomeConfig {
        system = "aarch64-darwin";
        configFile = ./home/darwin/home.nix;
      };

      "darwin-arm" = mkHomeConfig {
        system = "x86_64-darwin";
        configFile = ./home/darwin/home.nix;
      };

      # Linux configurations
      "linux-x86" = mkHomeConfig {
        system = "x86_64-linux";
        configFile = ./home/linux/home.nix;
      };

      "linux-arm" = mkHomeConfig {
        system = "aarch64-linux";
        configFile = ./home/linux/home.nix;
      };

      # Arch Linux configuration
      "arch" = mkHomeConfig {
        system = "x86_64-linux";
        configFile = ./home/arch/home.nix;
      };

    };
  };
}
