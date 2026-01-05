{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "gmk";
  networking.wireless.enable = true;

  services.k3s = {
    enable = true;
    tokenFile = "/root/.secret/k3s-token";
  };
}
