{...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    direnvrcExtra = ''

      echo "✨ direnv loaded!"

    '';
  };
}
