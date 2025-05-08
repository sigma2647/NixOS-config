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
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # cachix = {
    #   url = "github:cachix/cachix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # ghostty = {
    #   url = "github:ghostty-org/ghostty";
    # };
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, ... } @ inputs:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
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


    lib = nixpkgs.lib;

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
        ./modules/base.nix
        home-manager.nixosModules.home-manager {
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
    mkHomeConfig = { username, system, configFile, extraModules ? [], hostname ? null }: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [ configFile ] ++ extraModules;
      extraSpecialArgs = {
        inherit inputs username system hostname;
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

      "lawrence@fedora-alien" = mkHomeConfig {
        username = "lawrence";
        system = "x86_64-linux";
        configFile = ./users/lawrence/home.nix;
        hostname = "fedora-alien";
      };

      "lawrence@mac" = mkHomeConfig {
        username = "lawrence";
        system = "aarch64-darwin";
        configFile = ./users/lawrence/home.nix;
        hostname = "mac";
      };

      "lawrence@mini" = mkHomeConfig {
        username = "lawrence";
        system = "aarch64-darwin";
        configFile = ./users/lawrence/home.nix;
        hostname = "mini";
      };

    };
  };
}
