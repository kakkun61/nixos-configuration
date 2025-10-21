{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-configuration = {
      url = "github:kakkun61/nixos-configuration";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-configuration,
      nix-darwin,
      ...
    }:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # 元となる設定を選択する
            nixos-configuration.nixosModules.default
            # 共通でない設定は configuration.nix に書く
            ./configuration.nix
          ];
        };
      };
      darwinConfigurations = {
        default = nix-darwin.lib.darwinSystem {
          modules = [
            # 元となる設定を選択する
            nixos-configuration.darwinModules.default
            # 共通でない設定は configuration.nix に書く
            ./configuration.nix
          ];
        };
      };
    };
}
