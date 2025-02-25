# modules/python/tools.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.python.tools;
in {
  options.modules.python.tools = {
    enable = mkEnableOption "Enable Python tools";
    
    enableUV = mkOption {
      type = types.bool;
      default = true;
      description = "Enable uv package installer";
    };
    
    enablePipx = mkOption {
      type = types.bool;
      default = false;
      description = "Enable pipx for isolated package installation";
    };
    
    enablePip = mkOption {
      type = types.bool;
      default = true;
      description = "Enable pip package manager";
    };
    
    extraTools = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional Python tools to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; 
      (optional cfg.enableUV uv) ++
      (optional cfg.enablePipx python3Packages.pipx) ++
      (optional cfg.enablePip python3Packages.pip) ++
      cfg.extraTools;
      
    # 添加uv的配置如有需要
    environment.variables = mkIf cfg.enableUV {
      UV_SYSTEM_PYTHON = "1";  # 允许uv使用系统Python
    };
  };
} 
