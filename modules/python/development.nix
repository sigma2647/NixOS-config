# modules/python/development.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.python.development;
  pythonEnv = pkgs.${cfg.pythonVersion}.withPackages (ps: cfg.packages);
in {
  options.modules.python.development = {
    enable = mkEnableOption "Enable Python development environment";
    
    pythonVersion = mkOption {
      type = types.enum [ "python38" "python39" "python310" "python311" "python312" ];
      default = "python312";
      description = "Python version to use for development";
    };
    
    packages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = ps: with ps; [
        pip
        virtualenv
        ipython
      ];
      description = "Python packages to include in the development environment";
    };

    enableDevTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable development tools";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pythonEnv
    ] ++ optionals cfg.enableDevTools (with pkgs; [
      ruff
      black
      mypy
      pyright
      poetry
    ]);
  };
}
