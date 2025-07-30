{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.shell.starship;
in
{
  options.modules.shell.starship = {
    enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableTransience = true;
    };

    catppuccin.starship.enable = true;

    programs.fish = {
      functions.starship_transient_prompt_func.body = ''
        starship module character
      '';
    };
  };

}
