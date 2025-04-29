{pkgs, pkgs-unstable, ...}: let
    yazi-plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "...";
        hash = "sha256-...";
    };
in {
	programs.yazi = {
		enable = true;
    package = pkgs-unstable.yazi;  # 或者直接替换默认的 yazi
		enableZshIntegration = true;
		shellWrapperName = "y";

		settings = {
			manager = {
				show_hidden = false;
			};
			preview = {
				max_width = 1000;
				max_height = 1000;
			};
      opener = {
        edit = [
          {
            run = ''$EDITOR "$@"'';
            block = true;
            for = "unix";
          }
          {
            run = "nvim %*";
            block = true;
            desc = "nvim";
            for = "windows";
          }
        ];
        # xdg = [
        #   { run = ''xdg-open "$@"''; desc = "xdg-open"; for = "unix"; }
        # ];
      };
      # open.prepend_rules = [
      #   { mime = "*"; use = "xdg"; }
      # ];
		};

		# plugins = {
		# 	chmod = "${yazi-plugins}/chmod.yazi";
		# 	full-border = "${yazi-plugins}/full-border.yazi";
		# 	max-preview = "${yazi-plugins}/max-preview.yazi";
		# 	starship = pkgs.fetchFromGitHub {
		# 		owner = "Rolv-Apneseth";
		# 		repo = "starship.yazi";
		# 		rev = "...";
		# 		sha256 = "sha256-...";
		# 	};
		# };
        plugins = {
		    # lazygit = "${yazi-plugins}/lazygit.yazi";
		    # chmod = "${yazi-plugins}/chmod.yazi";
		};
		# initLua = ''
		# 	require("full-border"):setup()
		# 	require("starship"):setup()
		# '';

		keymap = {
			manager.prepend_keymap = [
				{
					on = "T";
					run = "plugin --sync max-preview";
					desc = "Maximize or restore the preview pane";
				}
				{
					on = ["c" "m"];
					run = "plugin chmod";
					desc = "Chmod on selected files";
				}
				{
					on = ["g" "o"];
					run = "cd ~/note/sigma/";
					desc = "Cd to note";
				}
				{
					on = ["g" "v"];
					run = "cd ~/.config/nvim";
					desc = "Cd to nvim config";
				}
				{
					on = ["<C-g>"];
					run = "shell --confirm --block lazygit";
					desc = "Lazygit";
				}
			];
		};
	};
}
# refer https://yazi-rs.github.io/docs/resources/
