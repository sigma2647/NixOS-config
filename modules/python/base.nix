# modules/python/default.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.python;
in {
  options.modules.python = {
    enable = mkEnableOption "Enable Python environment";
    
    enableNumpy = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NumPy support";
    };
    
    enableScientific = mkOption {
      type = types.bool;
      default = false;
      description = "Enable scientific Python libraries";
    };
    
    enableDevelopment = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Python development tools";
    };
    
    pythonVersion = mkOption {
      type = types.enum [ "python38" "python39" "python310" "python311" "python312" ];
      default = "python312";
      description = "Python version to use";
    };
    
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional Python packages to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Base Python installation
      (pkgs.${cfg.pythonVersion})
      
      # Package manager
      uv
      
      # Development tools
      (mkIf cfg.enableDevelopment (with pkgs; [
        # ruff
        # black
        # mypy
        # pyright
      ]))
    ] 
    ++ (if cfg.enableNumpy then [ 
      # Basic numerical packages
      # pkgs.${cfg.pythonVersion}Packages.numpy
      # pkgs.${cfg.pythonVersion}Packages.pandas
      blas
      lapack
      stdenv.cc.cc.lib
    ] else [])
    ++ (if cfg.enableScientific then [
      # Scientific computing packages
      pkgs.${cfg.pythonVersion}Packages.scipy
      pkgs.${cfg.pythonVersion}Packages.matplotlib
      pkgs.${cfg.pythonVersion}Packages.scikit-learn
      pkgs.${cfg.pythonVersion}Packages.jupyter
    ] else [])
    ++ cfg.extraPackages;
    
    # Make sure libraries are available
    programs.nix-ld.libraries = lib.optionals (cfg.enableNumpy || cfg.enableScientific) (with pkgs; [
      stdenv.cc.cc.lib
      blas
      lapack
    ]);
  };
}
