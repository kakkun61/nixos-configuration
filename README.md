# My Nix OS Configurations

## 使い方

_flake.example.nix_ の内容で _/etc/nixos/flake.nix_ を作成する。元となる設定を `nixos-configuration.nixosModules` から選択し、_/etc/nixos/configuration.nix_ に追加の設定を書く。

```
sudo nixos-rebuild switch --flake /etc/nixos#default
```

[home-manager の設定はこっち](https://github.com/kakkun61/dot_files/tree/master/home-manager)
