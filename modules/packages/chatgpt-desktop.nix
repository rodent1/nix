{
  internal.packageRecipes.chatgpt-desktop = ./_recipes/chatgpt-desktop.nix;

  perSystem =
    { pkgs, ... }:
    {
      packages.chatgpt-desktop = pkgs.chatgpt-desktop;
    };
}
