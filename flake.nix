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
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    in
  {
    homeConfigurations = {
      darwin = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-darwin"; };
        modules = [
          ./home/darwin/home.nix
        ];
      };

      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home/linux/home.nix
        ];
      };
    };

    # 配置 NixOS
    nixosConfigurations = {
      nix-home = let
        username = "sigma";
        specialArgs = {inherit username;};
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


      # nix-home = lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      #     ./hosts/nix-home
      #     home-manager.nixosModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.users.sigma = import ./home.nix;
      #     }
      #   ];
      # };

      jy-alien = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/jy-alien
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
