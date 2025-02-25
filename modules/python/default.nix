# modules/python/default.nix
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.python;
in {
  options.modules.python = {
    enable = mkEnableOption "Enable Python environment";
    
    # 基础工具选项
    enablePip = mkOption {
      type = types.bool;
      default = true;
      description = "Enable pip package manager";
    };
    
    enablePipx = mkOption {
      type = types.bool;
      default = true;
      description = "Enable pipx for isolated package installation";
    };
    
    enableUv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable uv package installer";
    };
    
    # 科学计算依赖
    enableNumpy = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NumPy support libraries";
    };
    
    # JupyterLab支持
    enableJupyter = mkOption {
      type = types.bool;
      default = false;
      description = "Enable JupyterLab";
    };
    
    jupyterPort = mkOption {
      type = types.int;
      default = 8888;
      description = "Port for JupyterLab";
    };
    
    # 额外包
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional Python packages to install";
    };
  };

  config = mkIf cfg.enable {
    # 安装Python包
    environment.systemPackages = with pkgs; [
      python3
    ] 
    ++ optional cfg.enablePip python3Packages.pip
    ++ optional cfg.enablePipx python3Packages.pipx
    ++ optional cfg.enableUv uv
    ++ optional cfg.enableJupyter python3Packages.jupyterlab
    ++ cfg.extraPackages;
    
    # 配置动态链接库
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ] 
      ++ optionals cfg.enableNumpy [
        blas
        lapack
      ];
    };
    
    # 环境变量
    environment.variables = {
      # 如果启用了uv，配置其使用系统Python
      UV_SYSTEM_PYTHON = mkIf cfg.enableUv "1";
    };
    
    # 如果启用JupyterLab，开放防火墙端口
    networking.firewall.allowedTCPPorts = 
      optional cfg.enableJupyter cfg.jupyterPort;
  };
}
