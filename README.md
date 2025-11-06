# My Nix OS Configurations

## 使い方

```
# mv /etc/nixos{,.back}
# ln -s $(pwd) /etc/nixos
# cp --force /etc/nixos{.back,}/hardware-configuration.nix
```

[home-manager の設定はこっち](https://github.com/kakkun61/dot_files/tree/master/home-manager)

## Usage

```
# mv /etc/nixos{,.back}
# ln -s $(pwd) /etc/nixos
# cp --force /etc/nixos{.back,}/hardware-configuration.nix
```

```
sudo nixos-rebuild switch --flake /etc/nixos#default
```

[Home-manager configuration is here](https://github.com/kakkun61/dot_files/tree/master/home-manager)
