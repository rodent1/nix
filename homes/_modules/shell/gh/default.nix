{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.shell.gh;
in
{
  options.modules.shell.gh = {
    enable = lib.mkEnableOption "gh";
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-copilot
        gh-fish
        gh-tidy
      ];
    };

    programs.fish.interactiveShellInit = ''
      source ~/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish
    '';
  };
}
