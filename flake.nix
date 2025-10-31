{
  description = "My Nix OS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
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
      commonModule =
        { pkgs, ... }:
        {
          config = {
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
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBpABK89ipLIn55ewoUsfufAwagz5k3C+WSdpQvgfMG JuiceSSH"
                ];
                packages = with pkgs; [ home-manager ];
                useDefaultShell = true;
              };
            };
          };
        };
      commonDarwinModule =
        args:
        let
          common = commonModule args;
        in
        {
          config = {
            nix = {
              settings = {
                experimental-features = common.config.nix.settings.experimental-features;
                trusted-users = [
                  "root"
                  "@admin"
                ];
              };
            };

            time = common.config.time;

            users.users.kazuki = {
              gid = "admin";
              createHome = true;
              home = "/Users/kazuki";
              openssh.authorizedKeys.keys = common.config.users.users.kazuki.openssh.authorizedKeys.keys;
              packages = common.config.users.users.kazuki.packages;
              shell = common.config.users.defaultUserShell;
            };

            security.pam.services.sudo_local.touchIdAuth = true;

            nixpkgs.hostPlatform = "aarch64-darwin";
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
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
        nixosModules = {
          common = commonModule;
          wsl =
            { ... }:
            {
              imports = [
                nixos-wsl.nixosModules.default
                commonModule
              ];
              config = {
                wsl.enable = true;
                wsl.defaultUser = "kazuki";
                wsl.interop.includePath = false;
                wsl.usbip.enable = true;
                wsl.wslConf.interop.appendWindowsPath = false;
                wsl.wslConf.user.default = "kazuki";
              };
            };
          work =
            { ... }:
            {
              imports = [ commonModule ];
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
            };
        };

        darwinModules = {
          common = commonDarwinModule;
          work =
            args@{ pkgs, ... }:
            {
              imports = [ (commonDarwinModule args) ];
              config = {
                system.configurationRevision = self.rev or self.dirtyRev or null;
                system.stateVersion = 5;
              };
            };
        };
      };
    };
}
