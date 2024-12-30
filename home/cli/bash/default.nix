{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;


    initExtra = ''
      export HISTSIZE=10000
      stty -ixon
      export HISTTIMEFORMAT="%F %T"
      export MANPAGER="nvim +Man!"


      f() {
        find . -iname "*$1*"
      }

      function y() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      	yazi "$@" --cwd-file="$tmp"
      	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      		builtin cd -- "$cwd"
      	fi
      	rm -f -- "$tmp"
      }
    '';
    
    shellAliases = {
      dot = "cd ~/dotfile";
      oo = "cd ~/note/sigma";
      mkdir = "mkdir -p";
      g = "lazygit";
      v = "nvim";
      t = "tmux";
      l = "y";

      myip = "curl ifconfig.me; echo";
    };
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
