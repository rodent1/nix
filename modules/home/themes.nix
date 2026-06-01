{ self, ... }:
{
  flake.homeModules.themes = {
    imports = [
      self.homeModules.themesCatppuccin
    ];
  };
}
