{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # 启用字体支持
  fonts = {
    # 启用默认字体包
    enableDefaultPackages = true;

    # 安装特定字体包
    packages = with pkgs; [
      corefonts         # Google 的核心字体
      font-awesome      # Font Awesome 图标字体
      maple-mono        # Maple Mono 字体
      # nerd-fonts       # 如果需要安装所有 Nerd Fonts，可以取消注释
      # nerd-fonts.fira-code  # 如果只需要特定的 Nerd Fonts，可以单独安装
      # nerd-fonts.jetbrains-mono
            # 从 unstable 频道获取最新nerd-fonts
      # (pkgs-unstable.nerdfonts.override {
      #   fonts = [ "jetbrains-mono" ];
      # })
      pkgs-unstable.nerd-fonts.jetbrains-mono
    ];

    # 配置 fontconfig
    fontconfig = {
      enable = true; # 启用 fontconfig

      # 自定义默认字体
      defaultFonts = {
        serif = [ "Times New Roman" ]; # 默认衬线字体
        sansSerif = [ "Arial" ];       # 默认无衬线字体
        monospace = [ "JetBrainsMono Nerd Font" "Maple Mono Nf" ]; # 默认等宽字体
      };

    };
  };
}
