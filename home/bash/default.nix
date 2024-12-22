{ pkgs, config, ... }:

{
  programs.bsh = {
    enable = true;

    shellAliases = {
      preview = true;
      ignorecases = true;
    };

  };
}
