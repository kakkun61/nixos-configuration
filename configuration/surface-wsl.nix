{
  networking.hostName = "surface-wsl";

  nixpkgs.config.allowUnfree = true;

  services.tailscale.enable = true;
}
