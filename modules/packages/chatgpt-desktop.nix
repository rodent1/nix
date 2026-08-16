{
  # TODO: Replace this recipe with the official nixpkgs package once it is merged.
  internal.packageRecipes.chatgpt-desktop = ./_recipes/chatgpt-desktop.nix;
  perSystem =
    { pkgs, ... }:
    {
      packages.chatgpt-desktop = pkgs.chatgpt-desktop;
    };
}
