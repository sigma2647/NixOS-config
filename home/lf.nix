{ pkgs, config, ... }:

{
  programsl.lf = {

    enabel = true;

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
