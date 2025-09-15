{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-configuration = {
      url = "github:kakkun61/nixos-configuration";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-configuration, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # 元となる設定を選択する
            nixos-configuration.nixosModules.default
            # 共通でない設定は configuration.nix に書く
            ./configuration.nix
          ];
        };
    };
  };
}
