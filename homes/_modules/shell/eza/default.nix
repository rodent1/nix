{ ... }:
{
  config = {
    programs.eza = {
      enable = true;
      icons = true;
      enableFishIntegration = false;
    };

    programs.fish = {
      shellAliases = {
        ls = "eza";
        la = "eza -al --group-directories-first";
        ld = "eza -lD";
        ll = "eza -l --group-directories-first";
        lh = "eza -dl .* --group-directories-first";
        lt = "eza -al --sort=modified";
      };
    };
  };
}
