{
  config,
  pkgs,
  ...
}: {
  containers.mysql = {
    autoStart = false;
    config = {
      services.mysql.enable = true;
      services.mysql.package = pkgs.mariadb;
      services.mysql.user = "root";
      services.mysql.initialScript = ./init.sql;
      services.mysql.settings = {
        mysqld = {
          bind-address = "0.0.0.0";  # 监听所有网络接口
        };
      };
    };
    ephemeral = true;
    bindMounts = {
      "/var/lib/mysql" = {
        # hostPath = "/path/to/mysql/data";  # 可选：如果你希望数据持久化
        isReadOnly = false;
      };
    };
  };
}
