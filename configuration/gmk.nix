{ ... }:

{
  imports = [
    ../hardware-configuration.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "gmk";
    networking.wireless.enable = true;

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
        };
      };
      openssh = {
        enable = true;
        extraConfig = ''
          AllowAgentForwarding yes
        '';
      };
    };

    system.stateVersion = "25.05";
  };
}
