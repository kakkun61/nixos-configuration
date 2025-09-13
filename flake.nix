{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      flake-parts,
      ...
    }:

    let
      system = "x86_64-linux";
      common-config =
        { pkgs, ... }:
        {
          nix.settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
          };

          time.timeZone = "Asia/Tokyo";
          i18n.defaultLocale = "ja_JP.UTF-8";

          programs.nix-ld.enable = true;

          users = {
            defaultUserShell = pkgs.bashInteractive;

            users.kazuki = {
              group = "wheel";
              # This automatically sets group to users, createHome to true, home to /home/«username», useDefaultShell to true, and isSystemUser to false.
              isNormalUser = true;
              openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKFQWOqFI7MX3rdZ6hNibGYDnZvBveyVEpeyiVNbWHfn+EWlDHSgOYNc8MCRaxYU+c89v6usZAGe7XDDj4QSEKwaNhFiCf30Jq5iihc9urc0K+fmwOSwDPgI5Hbr6BLqc3xdxhYzj2unzzcna9+1G32GX9SHz9nkSAgUV63wjSOx5hiQ2pDhk9xI/L63OjC0PVNw95wl1AA/+DZdmTpjcM+2V2Wx5ZL9LIM5lU5rXqHZ7RmOdSrjvB3aU+ju0XqfqR6Ixt10D+/8y5bn4/Pyz44PhPHC/dsI/y6Q7IEX8H0eCchmXtM2pH1LRNW1W52NkucmyJGwBrqHJLvdgMpPCU/32IR1OLNnoFodLkATgbSSONOQiGO8i07mwuSd2zQ7PUM1Qg98J3VR8YW8IJVQF4QJoBD0qREyIi4STe3r/Z8HJFBJsF+lSGgwBCUTUKEptMYQLAerk9uUbcmGM6ERhzAFZuPhTl/xEq4yK4+wTsf++87QkgWgaPHF16OUw2+Vjc45OzzfdjOuE09N38zk8GJCjV6NBpHgK9srvepccurC5jlcmUwGmdIq21OItHK6JCw18LG6T0pB5n/yiA+aV8ZJCoJkdS/p5+QMLmKiX15sAmyuSlLPgDAG6flhT2ppamZSbQDsC22fVaBH12dRIR+coaD1BbCKTlJYzyIz/8yw== kazuki@Maihama"
              ];
              packages = with pkgs; [ home-manager ];
              useDefaultShell = true;
            };
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ system ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          formatter = pkgs.nixfmt;
        };
      flake = {
        nixosConfigurations = {
          wsl = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              nixos-wsl.nixosModules.default
              { system.stateVersion = "24.05"; }
              # WSL config
              (
                { pkgs, ... }:
                {
                  wsl.enable = true;
                  wsl.defaultUser = "kazuki";
                  wsl.interop.includePath = false;
                  wsl.usbip.enable = true;
                  wsl.wslConf.interop.appendWindowsPath = false;
                  wsl.wslConf.user.default = "kazuki";
                }
              )
              common-config
            ];
          };
          work = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./hardware-configuration.nix
              { system.stateVersion = "24.05"; }
              (
                { pkgs, ... }:
                {
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
                }
              )
            ];
          };
        };
      };
    };
}
