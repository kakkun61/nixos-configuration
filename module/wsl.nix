{ ... }:
{
  imports = [ ./common.nix ];
  config = {
    wsl = {
      enable = true;
      defaultUser = "kazuki";
      interop.includePath = false;
      usbip.enable = true;
      wslConf = {
        interop.appendWindowsPath = false;
        user.default = "kazuki";
      };
    };
  };
}
