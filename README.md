# My Nix OS Configurations

## 使い方 / Usage

マシン名がまだ設定されていなかったら設定する。/ If the machine name is not set yet, set it.

```nix
…
  networking.hostName = "my-machine-name";
…
```

反映させる。/ Apply the changes.

```console
# nixos-rebuild switch
```

別マシンで、このリポジトリーに `my-machine-name` 用の設定を追加する。

- セットアップ対象のマシンの _/etc/nixos/configuration.nix_ を元に _configuration/my-machine-name.nix_ を作成する。/ Create _configuration/my-machine-name.nix_ based on _/etc/nixos/configuration.nix_ of the target machine.
- _flake.nix_ の `nixosConfigurations` に `my-machine-name` を追加する。/ Add `my-machine-name` to `nixosConfigurations` in _flake.nix_.

```nix
…
  nixosConfigurations = {
    …
    "my-machine-name" = nixpkgs.lib.nixosSystem {
      system = …;
      modules = [
        ./hardware-configuration.nix
        self.nixosModules.common
        ./configuration/my-machine-name.nix
        { system.stateVersion = …; }
      ];
      …
    };
  };
…
```

```console
$ nix fmt
$ git add .
$ git commit -m "Add configuration for my-machine-name"
$ git push
```

セットアップ対象のマシンで設定を適用する。/ Apply the configuration on the target machine.

```console
# nix-shell -p git gh
# gh auth login
# mv /etc/nixos{,.back}
# cd /etc
# gh repo clone kakkun61/nixos-configuration nixos
# cp --force /etc/nixos{.back,}/hardware-configuration.nix
# nix --extra-experimental-features 'nix-command flakes' flake update
```

[home-manager の設定はこっち](https://github.com/kakkun61/dot_files/tree/master/home-manager) / [Home-manager configuration is here](https://github.com/kakkun61/dot_files/tree/master/home-manager)
