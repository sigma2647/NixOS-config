nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable nixpkgs-unstable # 订阅镜像仓库频道
# nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixos-23.11 nixos        # 请注意系统版本
# nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixos-24.05 nixos        # 请注意系统版本
nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixos-24.11 nixpkgs        # 请注意系统版本
nix-channel --list                                                                  # 列出频道
nix-channel --update                                                                # 更新并解包频道
