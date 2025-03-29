mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
trusted-public-keys = tuna.tsinghua.edu.cn-2:TcFR7mxLGNUMz3hrSiqCJIxI/4BKH9ud5bf0cyNKOks= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF

export NIX_USER_CONF_FILES=$HOME/.config/nix/nix.conf
