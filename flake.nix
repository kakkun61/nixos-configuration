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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      nix-darwin,
      flake-parts,
      treefmt-nix,
      ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        {
          ...
        }:
        {
          treefmt = {
            programs.nixfmt.enable = true;
          };
        };
      flake = {
        nixosModules = {
          common = import ./module/common.nix;
          wsl = import ./module/wsl.nix { inherit nixos-wsl; };
          work = import ./module/work.nix;
          docker = import ./module/docker.nix;
        };

        darwinModules = {
          common = import ./module/common.darwin.nix;
          work = import ./module/work.darwin.nix;
        };

        nixosConfigurations = {
          gmk = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hardware-configuration.nix
              self.nixosModules.common
              ./configuration/gmk.nix
              { system.stateVersion = "25.05"; }
            ];
          };
          surface-wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              self.nixosModules.wsl
              self.nixosModules.docker
              ./configuration/surface-wsl.nix
              { system.stateVersion = "25.05"; }
            ];
          };
          utm = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./hardware-configuration.nix
              self.nixosModules.common
              ./configuration/utm.nix
              { system.stateVersion = "25.11"; }
            ];
          };
        };

        darwinConfigurations = {
          default = nix-darwin.lib.darwinSystem {
            modules = [
              # 元となる設定を選択する
              self.darwinModules.common
              # 共通でない設定は configuration.nix に書く
              # ./configuration.nix
            ];
          };
        };
      };
    };
}
