{pkgs, ...}: let
    yazi-plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "...";
        hash = "sha256-...";
    };
in {
	programs.yazi = {
		enable = true;
		enableZshIntegration = true;
		shellWrapperName = "y";

		settings = {
			manager = {
				show_hidden = true;
			};
			preview = {
				max_width = 1000;
				max_height = 1000;
			};
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
					on = ["g" "i"];
					run = "plugin lazygit";
					desc = "run lazygit";
				}
			];
		};
	};
}
# refer https://yazi-rs.github.io/docs/resources/
