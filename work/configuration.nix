# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  # /dev/sda は swap 用

  networking.hostName = "herp";

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "ja_JP.UTF-8";

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
      extraConfig =
        ''
          AllowAgentForwarding yes
        '';
    };
  };

  programs = {
    nix-ld.enable = true;
    ssh.startAgent = true;
  };

  virtualisation.docker.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [
      "root"
      "kazuki"
    ];
  };

  users.users.kazuki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKFQWOqFI7MX3rdZ6hNibGYDnZvBveyVEpeyiVNbWHfn+EWlDHSgOYNc8MCRaxYU+c89v6usZAGe7XDDj4QSEKwaNhFiCf30Jq5iihc9urc0K+fmwOSwDPgI5Hbr6BLqc3xdxhYzj2unzzcna9+1G32GX9SHz9nkSAgUV63wjSOx5hiQ2pDhk9xI/L63OjC0PVNw95wl1AA/+DZdmTpjcM+2V2Wx5ZL9LIM5lU5rXqHZ7RmOdSrjvB3aU+ju0XqfqR6Ixt10D+/8y5bn4/Pyz44PhPHC/dsI/y6Q7IEX8H0eCchmXtM2pH1LRNW1W52NkucmyJGwBrqHJLvdgMpPCU/32IR1OLNnoFodLkATgbSSONOQiGO8i07mwuSd2zQ7PUM1Qg98J3VR8YW8IJVQF4QJoBD0qREyIi4STe3r/Z8HJFBJsF+lSGgwBCUTUKEptMYQLAerk9uUbcmGM6ERhzAFZuPhTl/xEq4yK4+wTsf++87QkgWgaPHF16OUw2+Vjc45OzzfdjOuE09N38zk8GJCjV6NBpHgK9srvepccurC5jlcmUwGmdIq21OItHK6JCw18LG6T0pB5n/yiA+aV8ZJCoJkdS/p5+QMLmKiX15sAmyuSlLPgDAG6flhT2ppamZSbQDsC22fVaBH12dRIR+coaD1BbCKTlJYzyIz/8yw== kazuki@Maihama" ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

