{ secretPath, ... }:
{
  imports = [ ./secret.nix ];
  config = {
    services.k3s = {
      enable = true;
      tokenFile = "${secretPath}/k3s";
    };
  };
}
