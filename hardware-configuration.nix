# nix flake check を通すためのダミー
{
  fileSystems."/" = {
    device = "/dev/null";
  };
}
