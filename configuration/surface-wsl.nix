{ config, lib, pkgs, ... }:

{
  networking.hostName = "surface-wsl";

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  users.users.kazuki.extraGroups = [ "docker" ];

  system.stateVersion = "25.05";
}
