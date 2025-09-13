# My Nix OS Configurations

## 使い方

_/etc/nixos_ に clone する（か、_flake.nix_ のリンクを張る）。

`wsl` を有効にするなら、

```
sudo nixos-rebuild switch --flake /etc/nixos#wsl
```

[home-manager の設定はこっち](https://github.com/kakkun61/dot_files/tree/master/home-manager)
