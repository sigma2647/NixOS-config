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
    };
    ephemeral = true;
  };
}

