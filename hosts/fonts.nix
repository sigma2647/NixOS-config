{ config, pkgs, lib, ... }:
{
  fonts = {
    # 启用默认字体
    enableDefaultPackages = true;
    
    # 添加自定义字体包
    packages = with pkgs; [
      # Times New Roman 包含在 corefonts 中
      corefonts  # 微软核心字体
      
      # JetBrains Mono Nerd Font
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    
    # 设置字体配置
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Times New Roman" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}

