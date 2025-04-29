{ config, lib, pkgs, pkgs-unstable, ... }:

{
  # environment.systemPackages = with pkgs; [
  # ];

  programs.proxychains = {
    package = pkgs.proxychains;
    enable = true;
    proxies = {
      # 或者 "http  <代理IP> <端口> <用户名> <密码>"
      { myproxy =
        { type = "socks4";
          host = "127.0.0.1";
          port = 1337;
        };
      }
    };
  };

}
