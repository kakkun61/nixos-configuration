{
  services = {
    tailscale = {
      enable = true;
      authKeyFile = "/home/kazuki/.config/tailscale/auth.key";
    };
    # > Linuxディストリビューションのメンテナーの皆様は、ユーザーにどのような設定を強制すべきかお悩みかもしれません。
    # > 当社の見解では、systemd-resolvedを使用し、ユーザーフレンドリーなネットワーク設定が必要な場合は、
    # > 最新バージョンのNetworkManager（1.26.6以降）を採用することをお勧めします。
    # https://tailscale.com/blog/sisyphean-dns-client-linux
    resolved.enable = true;
  };
}
