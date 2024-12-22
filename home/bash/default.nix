{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      dot = "cd ~/dotfile";
      oo = "cd ~/note/sigma";
      mkdir = "mkdir -p";
      g = "lazygit";

      myip = "curl ifconfig.me; echo";
    };

    initExtra = ''
      HISTSIZE = 10000
      stty -ixon
      HISTTIMEFORMAT = "%F %T"


      f() {
        find . -iname "*$1*"
      }

    '';
    
    sessionVariables = {
      EDITOR = "nvim";
    };
    enableCompletion = true;

  };

  home.packages = with pkgs; [
    tree
    btop
    fastfetch
    ripgrep
  ];
}
