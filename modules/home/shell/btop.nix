{ ... }:
{
  flake.homeModules.shellBtop = {
    config = {
      programs.btop.enable = true;

      catppuccin.btop.enable = true;

      programs.fish.shellAliases.top = "btop";
    };
  };
}
