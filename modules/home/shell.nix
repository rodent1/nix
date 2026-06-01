{ self, ... }:
{
  flake.homeModules.shell = {
    imports = [
      self.homeModules.shellAtuin
      self.homeModules.shellBat
      self.homeModules.shellBtop
      self.homeModules.shellDoggo
      self.homeModules.shellEza
      self.homeModules.fish
      self.homeModules.git
      self.homeModules.shellMise
      self.homeModules.shellNixYourShell
      self.homeModules.shellNvim
      self.homeModules.shellStarship
      self.homeModules.shellTmux
      self.homeModules.shellUtilities
      self.homeModules.shellViddy
    ];
  };
}
