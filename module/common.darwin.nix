args:
let
  common = import ./common.nix args;
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
}
