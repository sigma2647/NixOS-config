{
  programs.git = {
    enable = true;
    userName = "sigma2647";
    userEmail = "1169446204@qq.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [
      # 操作系统相关
      ".DS_Store"      # macOS
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"    # Windows
      "Thumbs.db"
      "Desktop.ini"
      "*~"             # Linux备份文件

      # 编辑器相关
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"
      ".vim/"
      
      # 临时文件
      "*.tmp"
      "*.temp"
      "*.log"
      "*.bak"
      "*.orig"
      
      # 压缩文件
      "*.7z"
      "*.dmg"
      "*.gz"
      "*.iso"
      "*.jar"
      "*.rar"
      "*.tar"
      "*.zip"
      
      # 编译产物
      "*.o"
      "*.pyc"
      "*.pyo"
      "__pycache__/"
      ".pytest_cache/"
      "node_modules/"
      "dist/"
      "build/"
      "target/"
      
      # 环境配置
      ".env"
      ".env.local"
      ".env.*.local"
      
      # 版本控制
      ".svn/"
      ".hg/"
      
      # NixOS 相关
      "result"
      "result-*"
    ];
  };
}
