args@{ pkgs, self, ... }:
{
  imports = [ (import ./common.darwin.nix args) ];
  config = {
    system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 5;
  };
}
