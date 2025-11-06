{ ... }:
{
  imports = [ ./common.nix ];
  config = {
    wsl.enable = true;
    wsl.defaultUser = "kazuki";
    wsl.interop.includePath = false;
    wsl.usbip.enable = true;
    wsl.wslConf.interop.appendWindowsPath = false;
    wsl.wslConf.user.default = "kazuki";
  };
}
