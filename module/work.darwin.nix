{ self, ... }:
{
  imports = [ ./common.darwin.nix ];
  config = {
    system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 5;
  };
}
