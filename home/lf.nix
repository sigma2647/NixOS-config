{ pkgs, config, ... }:

{
  programs.lf = {

    enable = true;

    settings = {
      preview = true;
      ignorecases = true;
    };
    keybindings = {
      o = "";
      c = "mkdir";
      c = "mkdir";
      gh = "cd";
    };
  };
}
