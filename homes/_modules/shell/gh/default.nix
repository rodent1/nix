{ pkgs, ... }:
{

  config = {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-copilot
        gh-tidy
      ];
    };
  };
}
