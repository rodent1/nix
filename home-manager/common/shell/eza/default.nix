{ config, ... }:

{
  programs.eza = {
    enable = true;
    icons = true;
    enableAliases = true;
  };

  programs.fish.shellAliases = {
    ld = "eza -lD";
    lf = "eza -lF --color=always | grep -v /";
    lh = "eza -dl .* --group-directories-first";
    ll = "eza -al --group-directories-first";
    ls = "eza -alF --color=always --sort=size | grep -v /";
    lt = "eza -al --sort=modified";
  };
}
