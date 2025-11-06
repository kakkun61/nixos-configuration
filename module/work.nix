{ ... }:
{
  imports = [ ./common.nix ];
  config = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sdb";
    # /dev/sda は swap 用

    networking.hostName = "herp";

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

    virtualisation.docker.enable = true;
  };
}
