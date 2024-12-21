{pkgs, ...}:
# let
in {
	programs.tailscale = {
		enable = true;
		};
}
