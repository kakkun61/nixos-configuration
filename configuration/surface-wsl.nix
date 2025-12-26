{
  networking.hostName = "surface-wsl";

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  users.users.kazuki.extraGroups = [ "docker" ];
}
