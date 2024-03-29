# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "herp"; # Define your hostname.
  networking.firewall.enable = false;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
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

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "ja_JP.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kazuki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKFQWOqFI7MX3rdZ6hNibGYDnZvBveyVEpeyiVNbWHfn+EWlDHSgOYNc8MCRaxYU+c89v6usZAGe7XDDj4QSEKwaNhFiCf30Jq5iihc9urc0K+fmwOSwDPgI5Hbr6BLqc3xdxhYzj2unzzcna9+1G32GX9SHz9nkSAgUV63wjSOx5hiQ2pDhk9xI/L63OjC0PVNw95wl1AA/+DZdmTpjcM+2V2Wx5ZL9LIM5lU5rXqHZ7RmOdSrjvB3aU+ju0XqfqR6Ixt10D+/8y5bn4/Pyz44PhPHC/dsI/y6Q7IEX8H0eCchmXtM2pH1LRNW1W52NkucmyJGwBrqHJLvdgMpPCU/32IR1OLNnoFodLkATgbSSONOQiGO8i07mwuSd2zQ7PUM1Qg98J3VR8YW8IJVQF4QJoBD0qREyIi4STe3r/Z8HJFBJsF+lSGgwBCUTUKEptMYQLAerk9uUbcmGM6ERhzAFZuPhTl/xEq4yK4+wTsf++87QkgWgaPHF16OUw2+Vjc45OzzfdjOuE09N38zk8GJCjV6NBpHgK9srvepccurC5jlcmUwGmdIq21OItHK6JCw18LG6T0pB5n/yiA+aV8ZJCoJkdS/p5+QMLmKiX15sAmyuSlLPgDAG6flhT2ppamZSbQDsC22fVaBH12dRIR+coaD1BbCKTlJYzyIz/8yw== kazuki@Maihama" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs = {
    nix-ld.enable = true;
    ssh.startAgent = true;
  };

  nix.settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "herp-slum.cachix.org-1:6SC4HZSxqnmi6Jyxg+Omz+8o2uz8r4sgrz+cB1hn42I="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.iog.io"
        "https://iohk.cachix.org"
        "https://herp-slum.cachix.org"
      ];
      trusted-users = [
        "root"
        "kazuki"
      ];
  };

  virtualisation.docker.enable = true;
}
